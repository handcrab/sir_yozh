FactoryGirl.define do
  factory :channel do
    association :setup, factory: :setting

    factory :public_channel do
      title 'публичная подписка'
      source_url 'https://www.avito.ru/samarskaya_oblast?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9'
    end

    factory :private_channel do
      title 'скрытая подписка'
      source_url 'https://www.avito.ru/rossiya?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9'
      public false
    end

    factory :private_channel_ext do
      title 'чужая скрытая подписка'
      source_url 'https://www.avito.ru/rossiya?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9'
      public false
    end

    factory :public_channel_ext do
      title 'чужая публичная подписка'
      source_url 'https://www.avito.ru/samarskaya_oblast?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9'
    end

    factory :new_channel do
      title 'новая подписка'
      source_url 'https://www.avito.ru/samarskaya_oblast?q=%D0%B5%D0%B6%D0%B8%D0%BA+%D0%B0%D1%84%D1%80%D0%B8%D0%BA%D0%B0%D0%BD%D1%81%D0%BA%D0%B8%D0%B9'
    end
  end
end
