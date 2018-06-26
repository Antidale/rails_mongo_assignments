# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Racer.collection.delete_many
      Race.collection.delete_many
      Entrant.collection.delete_many
      @race1=Race.create(:name=>"Tomorrow's Race 1",:date=>Date.tomorrow)
      race2=Race.create(:name=>"Yesterday's Race",:date=>Date.yesterday)
      race3=Race.create(:name=>"Tomorrow's Race 2",:date=>Date.tomorrow)
      @racer=Racer.create(:first_name=>"thing",:last_name=>"two",:gender=>"M",:birth_year=>1960)
      race3.create_entrant(@racer)
