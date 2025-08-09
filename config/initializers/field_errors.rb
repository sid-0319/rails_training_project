# Prevent Rails from breaking Bootstrap input groups with field_with_errors
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag =~ /<input/ && html_tag.include?('type="number"') && html_tag.include?('name="menu_item[price]')
    # Keep original HTML, but add is-invalid class for Bootstrap styling
    html_tag = html_tag.sub('class="', 'class="is-invalid ')
  end

  # For all other fields, keep default wrapper but inline for bootstrap
  if html_tag =~ /<label/ || html_tag =~ /<textarea/ || html_tag =~ /<select/ || html_tag =~ /<input/
    html_tag.html_safe
  else
    "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
  end
end
