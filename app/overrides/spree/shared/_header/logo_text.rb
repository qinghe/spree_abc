Deface::Override.new(:virtual_path  => "spree/shared/_header",
                     :replace_contents => "figure#logo",
                     :text          => "<%= logo_text %>",
                     :name          => "logo_text")