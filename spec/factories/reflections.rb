FactoryGirl.define do
  factory :reflection do
    title { FFaker::HipsterIpsum.phrase }
    body { FFaker::HipsterIpsum.paragraph(2) }
    user

    factory :invalid_reflection do
      title nil
    end

    factory :reflection_too_long_title do
      title { SecureRandom.urlsafe_base64(101) }
    end

    factory :reflection_too_long_body do
      body { FFaker::HipsterIpsum.paragraph(35) }
    end

  end
end
