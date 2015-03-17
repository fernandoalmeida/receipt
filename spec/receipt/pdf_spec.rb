describe Receipt::Pdf do
  subject(:receipt) { described_class.new(params) }

  let(:params) do
    {
      id: 1,
      date: date,
      amount: 100.0,
      currency: '$',
      payer: 'Chucky Norris',
      receiver: 'Fernando Almeida',
      description: 'transaction #123',
      logo: 'logo.png',
      location: 'Sao Paulo',
      locale: :en
    }
  end

  let(:date) { Date.new(2015, 03, 10) }

  let(:strings) { PDF::Inspector::Text.analyze(subject.data).strings.join }
  let(:pages) { PDF::Inspector::Page.analyze(subject.data).pages }

  describe '#initialize' do
    it { expect(receipt.id).to eq(1) }
    it { expect(receipt.date).to eq(date) }
    it { expect(receipt.amount).to eq(100.0) }
    it { expect(receipt.currency).to eq('$') }
    it { expect(receipt.payer).to eq('Chucky Norris') }
    it { expect(receipt.receiver).to eq('Fernando Almeida') }
    it { expect(receipt.description).to eq('transaction #123') }
    it { expect(receipt.logo).to eq('logo.png') }
    it { expect(receipt.location).to eq('Sao Paulo') }

    context 'when the currency is empty' do
      before { params.delete(:currency) }

      it 'uses a default currency' do
        expect(receipt.currency).to eq('$')
      end

      it 'select default by locale' do
        params.merge!(locale: 'pt-BR')
        expect(receipt.currency).to eq('R$')
      end
    end
  end

  describe '#valid?' do
    it { expect(receipt.valid?).to be_truthy }

    context 'when is not valid' do
      before { params.delete(:id) }

      it { expect(receipt.valid?).to be_falsy }

      [:id, :amount, :payer, :receiver, :description].each do |p|
        it "validates the presence of #{p}" do
          params.delete(p)
          receipt.valid?

          expect(receipt.errors[p]).to eq('required param not found')
        end
      end
    end
  end

  describe '#data' do
    it { expect(receipt.data).to be_truthy }
    it { expect(pages.size).to eq(1) }
    it { expect(strings).to include('RECEIPT') }
    it { expect(strings).to include('Number: 1') }
    it { expect(strings).to include('Amount: $ 100.0') }
    it { expect(strings).to include('Received from Chucky Norris') }
    it { expect(strings).to include('the amount of $ 100.0') }
    it { expect(strings).to include('relating to transaction #123') }
    it { expect(strings).to include('Sao Paulo, March 10, 2015') }
    it { expect(strings).to include('Fernando Almeida') }
  end

  describe '#file' do
    subject(:file) { receipt.file }

    it { expect(file).to be_truthy }
    it { expect(file).to match(/(pdf)$/) }
    it { expect(File.exist?(file)).to be_truthy }
  end

  describe '#before_receipt_box' do
    subject(:receipt_with_content_before_receipt_box) do
      receipt.tap do |r|
        r.before_receipt_box { r.text(text) }
      end
    end

    let(:text) { 'content before receipt box' }

    it { expect(strings).to include(text) }
  end

  describe '#after_receipt_box' do
    subject(:receipt_with_content_after_receipt_box) do
      receipt.tap do |r|
        r.after_receipt_box { r.text(text) }
      end
    end

    let(:text) { 'content after receipt box' }

    it { expect(strings).to include(text) }
  end

  describe '#mimetype' do
    subject(:mimetype) { receipt.mimetype }

    it { is_expected.to eq 'application/pdf' }
  end

  describe '#filename' do
    subject(:filename) { receipt.filename }

    it { is_expected.to match(/^Receipt.*1.pdf$/) }

    context 'when a filepath is passed' do
      let(:receipt) { described_class.new(params.merge(filepath)) }
      let(:filepath) { { filepath: '/tmp/custom.pdf' } }

      it { is_expected.to eq('custom.pdf') }
    end
  end
end
