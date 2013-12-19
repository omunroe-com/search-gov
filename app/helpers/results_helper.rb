module ResultsHelper
  def search_data(search, search_vertical)
    { data: {
        a: search.affiliate.name,
        l: search.affiliate.locale,
        q: search.query,
        s: search.module_tag,
        t: search.queried_at_seconds,
        v: search_vertical }
    }
  end

  def link_to_best_bet_title(hit, url, position, source, options = {})
    title = options[:title] || highlight_hit(hit, :title).html_safe
    click_data = { i: hit.instance.id, p: position, s: source }

    link_to_if url.present?, title, url, data: { click: click_data }
  end

  def link_to_featured_collection_title(id, title, url, position)
    click_data = { i: id, p: position, s: 'BBG' }
    link_to_if url.present?, title.html_safe, url, data: { click: click_data }
  end

  def link_to_web_result_title(search, result, position)
    title = translate_bing_highlights(
        h(result['title']),
        excluded_highlight_terms(search.affiliate, search.query)).html_safe

    click_data = { p: position }
    link_to title, result['unescapedUrl'], data: { click: click_data }
  end

  def link_to_news_item_title(hit, hit_url, position)
    title = highlight_hit(hit, :title).html_safe
    module_tag = hit.instance.is_video? ? 'VIDS' : 'NEWS'

    click_data = { p: position, s: module_tag }
    link_to title, hit_url, data: { click: click_data }
  end

  def link_to_related_search(search, related_term, position)
    click_data = { p: position, s: 'SREL' }
    link_to related_term.downcase.html_safe,
            search_path(affiliate: search.affiliate.name, query: strip_tags(related_term)),
            data: { click: click_data }
  end
end