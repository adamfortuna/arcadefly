function toggleLabel(element, show) {
  show && $("#"+element).val() == '' ? $("#"+element+'_label').show() : $("#"+element+'_label').hide();
}