FactoryGirl.define do
  factory :user do
    factory :vasia do
      name 'Вася Пупкин'
      email 'vasia@pipkin.ru'
      password '12345678'
    end
    
    factory :hodor do
      name 'Hodor Hodor'
      email 'hodor@hodor.hodor'
      password '12345678'
    end

  end
end
