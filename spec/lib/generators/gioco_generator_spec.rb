require "generators/gioco_generator"

RSpec.describe GiocoGenerator do
  describe "#execute" do
    let(:model) { 'user'.freeze }

    context 'setting up gioco with badges architecture' do
      let(:subject) { GiocoGenerator.new([ model ], badges: true) }

      it "generates the badges model and inject the relationships" do
        allow(subject).to receive(:inject_into_class)

        expect(subject).to receive(:generate).with("model", "badge name:string")
        expect(subject).to receive(:generate).with("migration", "create_badges_and_#{model.pluralize} badge:references #{model}:references")
        expect(subject).to receive(:inject_into_class).with("app/models/badge.rb", 'Badge', "has_and_belongs_to_many :users\n")
        expect(subject).to receive(:inject_into_class).with("app/models/#{model}.rb", model.capitalize, "has_and_belongs_to_many :badges\n")

        subject.execute
      end
    end
  end
end
