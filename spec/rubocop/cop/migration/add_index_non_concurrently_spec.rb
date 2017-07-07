describe RuboCop::Cop::Migration::AddIndexNonConcurrently do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  shared_examples "a non-concurrent index" do
    it "registers an offense" do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to eq("Use `algorithm: :concurrently` to avoid locking database.")
      expect(cop.highlights).to eq([source])
    end
  end

  shared_examples "a valid index" do
    it "doesn't register an offense" do
      expect(cop.offenses).to be_empty
    end
  end

  context "add_index" do
    context "basic source, non-concurrent" do
      let(:source) { "add_index :users, :some_column" }

      it_behaves_like "a non-concurrent index"
    end

    context "complex source, non-concurrent" do
      let(:source) { "add_index :users, [:some_column, :another], unique: true, algorithm: :btree, something: {nested: 1}" }

      it_behaves_like "a non-concurrent index"
    end

    context "basic source, concurrent" do
      let(:source) { "add_index :users, :some_column, algorithm: :concurrently" }

      it_behaves_like "a valid index"
    end

    context "complex source, concurrent" do
      let(:source) { "add_index :users, [:some_column, :another], unique: true, algorithm: 'concurrently', something: {nested: 1}" }

      it_behaves_like "a valid index"
    end
  end

  context "add_reference" do
    context "no index being added" do
      let(:source) { "add_reference :products, :user" }

      it_behaves_like "a valid index"
    end

    context "no index being added (index: false)" do
      let(:source) { "add_reference :products, :user, index: false" }

      it_behaves_like "a valid index"
    end

    context "non-concurrent, basic source" do
      let(:source) { "add_reference :products, :user, index: true" }

      it_behaves_like "a non-concurrent index"
    end

    context "non-concurrent, complex source" do
      let(:source) { "add_reference :products, :user, polymorphic: true, index: {name: 'myindex', unique: true}, foreign_key: {to_table: :supplier}" }

      it_behaves_like "a non-concurrent index"
    end

    context "concurrent, basic source" do
      let(:source) { "add_reference :products, :user, index: {algorithm: :concurrently}" }

      it_behaves_like "a valid index"
    end

    context "concurrent, complex source" do
      let(:source) { "add_reference :products, :user, polymorphic: true, index: {unique: true, algorithm: 'concurrently'}, foreign_key: {to_table: :supplier}" }

      it_behaves_like "a valid index"
    end
  end
end
