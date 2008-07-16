// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function toggleLabel(show) {
  show && $F('search') == '' ? $('search_label').show() : $('search_label').hide();
}