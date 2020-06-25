module SpreeTheme
  module SitemapHelper
    # https://github.com/spree-contrib/spree_sitemap

    def add_product(product, taxon, options = {})
      opts = options.merge(lastmod: product.updated_at)
      add( product.build_path( taxon ), opts)
    end

    def add_post(post, taxon, options = {})
      opts = options.merge(lastmod: post.updated_at)
      add( post.build_path( taxon ), opts)
    end

    def add_taxon(taxon, options = {})
      add( taxon.build_path, options.merge(lastmod: taxon.products.last_updated)) if taxon.permalink.present?
    end


  end
end
