describe RuboCop::Cop::Migration::UnsafeOperation do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  shared_examples "valid code" do
    it "doesn't register an offense" do
      expect(cop.offenses).to be_empty
    end
  end

  context "a non-migration class" do
    let(:source) do
      <<-SOURCE
      class MyModel < ActiveRecord::Base
      end
      SOURCE
    end

    it_behaves_like "valid code"
  end

  context "a valid migration class" do
    let(:source) do
      <<-SOURCE
      class AddSomeColumnToUsers < ActiveRecord::Migration[5.0]
        def change
          # Some comment
          if data_source_exists?
            add_column :users, :some_id, :integer
            add_index :users, :some_id, algorithm: :concurrently
            add_reference :users, :something, index: false
          end
        end
      end
      SOURCE
    end

    it_behaves_like "valid code"
  end

  context "add_index non-concurrently" do
    let(:source) do
      <<-SOURCE
      class AddSomeColumnToUsers < ActiveRecord::Migration
        def change
          add_column :users, :some_id, :integer
          add_index :users, :some_id
        end
      end
      SOURCE
    end

    it "registers an offense" do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to match(/\AAdding a non-concurrent index/)
      expect(cop.highlights).to eq(["add_index :users, :some_id"])
    end
  end

  context "add_reference with an index non-concurrently" do
    let(:source) do
      <<-SOURCE
      class AddSomeColumnToUsers < ActiveRecord::Migration
        def change
          add_reference :users, :something, index: true
        end
      end
      SOURCE
    end

    it "registers an offense" do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to match(/\AAdding a non-concurrent index/)
      expect(cop.highlights).to eq(["add_reference :users, :something, index: true"])
    end
  end

  context "add_column with default value" do
    let(:source) do
      <<-SOURCE
      class AddSomeColumnToUsers < ActiveRecord::Migration
        def change
          add_column :users, :schmuck, :boolean, default: false
        end
      end
      SOURCE
    end

    it "registers an offense" do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to match(/\AAdding a column with a non-null default/)
      expect(cop.highlights).to eq(["add_column :users, :schmuck, :boolean, default: false"])
    end
  end
end
