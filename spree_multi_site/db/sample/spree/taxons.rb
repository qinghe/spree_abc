# Fixtures were created for acts_as_adjency_list, but now we have nested set, so we need to rebuild it after import
#  root Categories
#          +-   Bags(ror_tote, ror_bag, spree_tote, spree_bag)
#          +-   Mugs(ror_mug, ror_stein, spree_stein, spree_mug)
#          +-   Clothing
#                  +-   Shirts(ror_jr_spaghetti, spree_jr_spaghetti)
#                  +-   T-Shirts(ror_baseball_jersey, ror_ringer, apache_baseball_jersey, ruby_baseball_jersey, spree_baseball_jersey, spree_ringer)
#  root Brands
#          +-   Ruby
#          +-   Ruby on Rails
#          +-   Apache
#          +-   Spree

Spree::Taxon.rebuild!
Spree::Taxon.all.each{ |t| t.send(:set_permalink); t.save }
