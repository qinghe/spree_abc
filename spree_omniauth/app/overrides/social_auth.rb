Deface::Override.new(:virtual_path => "spree/user_registerations/new",
                     :name => "insert social auth",
                     :insert_top => "[data-hook='login_extras']",
                     :partial => "shared/social_auth",
                     :original => '9545f08a85b960009d04d0d3d598ae331641077f')

Deface::Override.new(:virtual_path => "spree/user_sessions/new",
                    :name => "insert social auth",
                    :insert_top => "[data-hook='login_extras']",
                    :partial => "shared/social_auth",
                    :original => '9545f08a85b960009d04d0d3d598ae331641077f')
