# Dugway CHANGELOG

An overview of the changes per-version for the Dugway gem.

## [Unreleased]

- Switch from Travis CI to GitHub Actions for project CI
- Support Ruby 2.7.x
- Add `ProductDrop#related_products`, which returns a `ProductsDrop` for rendering related products for a given one
- Add `sample` filter for collections with support for one or more random items, examples: `{{ products.all | sample}}`, `{{ products.all | sample: 2 }}`
