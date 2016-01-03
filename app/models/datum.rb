class Datum
  include Mongoid::Document

  store_in collection: 'dataPoint', database: 'omh'

  embedded_in :body, :inverse_of => :data


## for knee
  field :RisefromSitting, type: String
  field :TwistPivot, type: String
  field :KneePainSeverity, type: Float
  field :Bed, type: String
  field :Bending, type: String
  field :Kneeling, type: String
  field :Socks, type: String
  field :Squatting, type: String

## for sleep survey

  field :drink, type: String
  field :sleep_rate, type: Integer
  field :groggy, type: String
  field :stress, type: String
  field :snoring, type: String
  field :full_sleep_description, type: String
  field :myTimestamp, type: String
  field :wakeup, type: String
  field :sleep_hours, type: Integer
  field :memory, type: String


## For Colectomy

  field :ColIl, type: String
  field :ProviderContactDarkUrine, type: Integer
  field :MealPercent, type: Integer
  field :IleostomyOutput, type: String
  field :painLevel, type: Integer
  field :LiquidIntake, type: Integer
  field :InterfereGenAct, type: Integer
  field :Symptoms, type: String
  field :ProviderContactMealPercent, type: Integer
  field :InterfereSleep, type: Integer
  field :InterfereRelations, type: Integer
  field :OstomyOutput, type: String
  field :MealPercentReason, type: String
  field :Vomiting, type: Integer
  field :ProviderContactOstomy, type: Integer


## For RA
  field :SleepHour, type: Integer
  field :ExtraMedOther, type: String
  field :RAChange, type:Integer
  field :ExtraMed, type: String
  field :RAToday, type: String
  field :MissedMedOther, type: String
  field :Unwell, type: String
  field :Sleep,type: Integer
  field :Focus, type: Integer
  field :MissedMed, type: Integer
  field :Worry, type: Integer

## For compliance
  field :HoursWithPhoneOn, type: String
  field :ActivityDuringPhoneOff, type: String
  field :ActivityDuringPhoneOffOther, type: String
  field :TurnOffApp, type: Integer
  field :ReasonToTurnOffApp, type: String
  field :ReasonToTurnOffAppOther, type: String
  field :PhoneIsPhysicallyOnHours, type: String
  field :PhonePhysicallyOn, type: String
  field :PhonePhysicallyOther, type: String
  field :PhoneNotPhysicallyOnAct, type: String
  field :PhoneNotPhysicallyOnActivityOther, type: String


## For non-stoma
  field :InterfereGenAct, type: Integer
  field :ProviderContactHighTemperature, type: Integer
  field :PainLevel, type: Integer
  field :UrinePhoto, type: String
  field :LiquidIntake, type: Integer
  field :Vomiting, type: Integer
  field :Symptoms, type: String
  field :HighTemperature, type: Integer
  field :InterfereRelations, type: Integer
  field :UrineOutput, type: String
  field :BMConsistency, type: String
  field :MealPercentReason, type: String
  field :InterfereSleep, type: Integer
  field :MealPercent, type: Integer
  field :BowelMovements, type: Integer
  field :Temperature, type: Integer

## For hip
  field :Activities, type: String
  field :Lifestyle, type: String
  field :Stairs, type: String
  field :Confidence, type: String
  field :Sitting, type: String
  field :Pain, type: Integer
  field :Rising, type: String
  field :Difficulty, type: String
  field :Uneven, type: String
  field :Bed, type: String
  field :Aware, type: String
  field :JobDemands, type: String
  field :Work, type: String

end