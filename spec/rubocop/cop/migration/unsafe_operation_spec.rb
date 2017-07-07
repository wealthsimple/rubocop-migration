describe RuboCop::Cop::Migration::UnsafeOperation do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  # shared_examples "a non-concurrent index" do
  #   it "registers an offense" do
  #     expect(cop.offenses.size).to eq(1)
  #     expect(cop.offenses.first.message).to eq("Use `algorithm: :concurrently` to avoid locking table.")
  #     expect(cop.highlights).to eq([source])
  #   end
  # end
  #
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

  context "a valid migration class", :focus do
    let(:source) do
      <<-SOURCE
      class AddSomeColumnToUsers < ActiveRecord::Migration[5.0]
        def change
          # Some comment
          if data_source_exists?
            add_column :users, :some_id, :integer
            add_index :users, :some_id, algorithm: :concurrently
          end
        end
      end
      SOURCE
    end

    it_behaves_like "valid code"
  end

  context "non-concurrent" do
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

    end
  end
end
