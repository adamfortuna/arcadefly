// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function toggleLabel(element, show) {
  show && $F(element) == '' ? $(element+'_label').show() : $(element+'_label').hide();
}

function check_all(selector) {
	$$(selector).each(function(el) {
		el.checked = true;
	});
}

function uncheck_all(selector) {
	$$(selector).each(function(el) {
		el.checked = false;
	});
}