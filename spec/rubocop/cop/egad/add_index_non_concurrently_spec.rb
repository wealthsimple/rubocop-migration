describe RuboCop::Cop::Egad::AddIndexNonConcurrently do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  context "add_index" do
    context "basic source, non-concurrent" do
      let(:source) { "add_index :users, :some_column" }

      it "registers an offense" do
        expect(cop.offenses.size).to eq(1)
        expect(cop.offenses.first.message).to eq("Use `algorithm: :concurrently` to avoid locking database.")
        expect(cop.highlights).to eq([source])
      end
    end

    context "complex source, non-concurrent" do
      let(:source) { "add_index :users, [:some_column, :another], unique: true, algorithm: :btree, something: {nested: 1}" }

      it "registers an offense" do
        expect(cop.offenses.size).to eq(1)
        expect(cop.offenses.first.message).to eq("Use `algorithm: :concurrently` to avoid locking database.")
        expect(cop.highlights).to eq([source])
      end
    end

    context "basic source, concurrent" do
      let(:source) { "add_index :users, :some_column, algorithm: :concurrently" }

      it "doesn't register an offense" do
        expect(cop.offenses).to be_empty
      end
    end

    context "complex source, concurrent" do
      let(:source) { "add_index :users, [:some_column, :another], unique: true, algorithm: 'concurrently', something: {nested: 1}" }

      it "doesn't register an offense" do
        expect(cop.offenses).to be_empty
      end
    end
  end
end
