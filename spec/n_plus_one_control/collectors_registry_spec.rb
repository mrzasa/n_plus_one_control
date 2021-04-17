# frozen_string_literal: true

require "spec_helper"

describe NPlusOneControl::CollectorsRegistry do
  describe ".register" do
    subject(:register) { described_class.register :__test_register, :SomeCollector }

    after { described_class.unregister(:__test_register) }

    specify do
      register
      expect(described_class.collectors[:__test_register]).to eq(:SomeCollector)
    end
  end

  describe ".slice" do
    subject(:sliced_collectors) { described_class.slice(*collector_keys) }

    let(:collector_keys) { [:db] }

    specify { expect(sliced_collectors).to eq(db: ::NPlusOneControl::Collectors::DB) }

    context "when undefined key passed" do
      let(:collector_keys) { [:__test_slice_undefined_key] }

      specify { expect { sliced_collectors }.to raise_error(ArgumentError, /: __test_slice_undefined_key, exsiting collectors are: db/) }
    end
  end
end
