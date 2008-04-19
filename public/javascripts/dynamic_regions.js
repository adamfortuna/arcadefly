// javascripts/dynamic_regions.js.erb
var regions = new Array();
  regions.push(new Array(1, 'Alaska', 1));
  regions.push(new Array(1, 'Alabama', 2));
  regions.push(new Array(1, 'Arkansas', 3));
  regions.push(new Array(1, 'Arizona', 4));
  regions.push(new Array(1, 'California', 5));
  regions.push(new Array(1, 'Colorado', 6));
  regions.push(new Array(1, 'Connecticut', 7));
  regions.push(new Array(1, 'District of Columbia', 8));
  regions.push(new Array(1, 'Delaware', 9));
  regions.push(new Array(1, 'Florida', 10));
  regions.push(new Array(1, 'Georgia', 11));
  regions.push(new Array(1, 'Hawaii', 12));
  regions.push(new Array(1, 'Iowa', 13));
  regions.push(new Array(1, 'Idaho', 14));
  regions.push(new Array(1, 'Illinois', 15));
  regions.push(new Array(1, 'Indiana', 16));
  regions.push(new Array(1, 'Kansas', 17));
  regions.push(new Array(1, 'Kentucky', 18));
  regions.push(new Array(1, 'Louisiana', 19));
  regions.push(new Array(1, 'Massachusetts', 20));
  regions.push(new Array(1, 'Maryland', 21));
  regions.push(new Array(1, 'Maine', 22));
  regions.push(new Array(1, 'Michigan', 23));
  regions.push(new Array(1, 'Minnesota', 24));
  regions.push(new Array(1, 'Missouri', 25));
  regions.push(new Array(1, 'Mississippi', 26));
  regions.push(new Array(1, 'Montana', 27));
  regions.push(new Array(1, 'North Carolina', 28));
  regions.push(new Array(1, 'North Dakota', 29));
  regions.push(new Array(1, 'Nebraska', 30));
  regions.push(new Array(1, 'New Hampshire', 31));
  regions.push(new Array(1, 'New Jersey', 32));
  regions.push(new Array(1, 'New Mexico', 33));
  regions.push(new Array(1, 'Nevada', 34));
  regions.push(new Array(1, 'New York', 35));
  regions.push(new Array(1, 'Ohio', 36));
  regions.push(new Array(1, 'Oklahoma', 37));
  regions.push(new Array(1, 'Oregon', 38));
  regions.push(new Array(1, 'Pennsylvania', 39));
  regions.push(new Array(1, 'Rhode Island', 40));
  regions.push(new Array(1, 'South Carolina', 41));
  regions.push(new Array(1, 'South Dakota', 42));
  regions.push(new Array(1, 'Tennessee', 43));
  regions.push(new Array(1, 'Texas', 44));
  regions.push(new Array(1, 'Utah', 45));
  regions.push(new Array(1, 'Virginia', 46));
  regions.push(new Array(1, 'Vermont', 47));
  regions.push(new Array(1, 'Washington', 48));
  regions.push(new Array(1, 'Wisconsin', 49));
  regions.push(new Array(1, 'West Virginia', 50));
  regions.push(new Array(1, 'Wyoming', 51));
  regions.push(new Array(2, 'Alberta', 52));
  regions.push(new Array(2, 'British Columbia', 53));
  regions.push(new Array(2, 'Manitoba', 54));
  regions.push(new Array(2, 'Newfoundland and Labrador', 55));
  regions.push(new Array(2, 'New Brunswick', 56));
  regions.push(new Array(2, 'Nova Scotia', 57));
  regions.push(new Array(2, 'Ontario', 58));
  regions.push(new Array(2, 'Prince Edward Island', 59));
  regions.push(new Array(2, 'Quebec', 60));
  regions.push(new Array(2, 'Saskatchewan', 61));

function countrySelected(selectedValue) {
  selectedValue = selectedValue || '';
  country_id = $('address_country_id').getValue();
  options = $('address_region_id').options;
  options.length = 1;
  regions.each(function(region) {
    if (region[0] == country_id) {
      options[options.length] = new Option(region[1], region[2]);
      if (selectedValue == region[2]) {
        options.selectedIndex = options.length-1;
      }
    }
  });
  if (options.length == 1) {
    $('address_region_id_field').hide();
  } else {
    $('address_region_id_field').show();
  }
}

Event.observe(window, 'load', function() {
  countrySelected($('address_region_id').value);
  $('address_country_id').observe('change', countrySelected);
});