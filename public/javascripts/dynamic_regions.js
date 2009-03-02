var regions = new Array();
  regions.push(new Array(7, 'Aguascalientes', 74));
  regions.push(new Array(1, 'Alabama', 2));
  regions.push(new Array(1, 'Alaska', 1));
  regions.push(new Array(4, 'Alberta', 51));
  regions.push(new Array(1, 'Arizona', 4));
  regions.push(new Array(1, 'Arkansas', 3));
  regions.push(new Array(7, 'Baja California', 75));
  regions.push(new Array(7, 'Baja California Sur', 76));
  regions.push(new Array(4, 'British Columbia', 52));
  regions.push(new Array(1, 'California', 5));
  regions.push(new Array(7, 'Campeche', 77));
  regions.push(new Array(7, 'Chiapas', 78));
  regions.push(new Array(7, 'Chihuahua', 79));
  regions.push(new Array(7, 'Coahuila', 80));
  regions.push(new Array(7, 'Colima', 81));
  regions.push(new Array(1, 'Colorado', 6));
  regions.push(new Array(1, 'Connecticut', 7));
  regions.push(new Array(1, 'Delaware', 9));
  regions.push(new Array(1, 'Dist. of Columbia', 8));
  regions.push(new Array(7, 'Durango', 82));
  regions.push(new Array(1, 'Florida', 10));
  regions.push(new Array(1, 'Georgia', 11));
  regions.push(new Array(1, 'Guam', 62));
  regions.push(new Array(7, 'Guanajuato', 83));
  regions.push(new Array(7, 'Guerrero', 84));
  regions.push(new Array(1, 'Hawaii', 12));
  regions.push(new Array(7, 'Hidalgo', 85));
  regions.push(new Array(1, 'Idaho', 14));
  regions.push(new Array(1, 'Illinois', 15));
  regions.push(new Array(1, 'Indiana', 16));
  regions.push(new Array(1, 'Iowa', 13));
  regions.push(new Array(7, 'Jalisco', 86));
  regions.push(new Array(1, 'Kansas', 17));
  regions.push(new Array(1, 'Kentucky', 18));
  regions.push(new Array(1, 'Louisiana', 19));
  regions.push(new Array(1, 'Maine', 22));
  regions.push(new Array(4, 'Manitoba', 53));
  regions.push(new Array(1, 'Maryland', 21));
  regions.push(new Array(1, 'Massachusetts', 20));
  regions.push(new Array(7, 'Mexico State', 87));
  regions.push(new Array(1, 'Michigan', 23));
  regions.push(new Array(7, 'Michoacan', 89));
  regions.push(new Array(1, 'Minnesota', 24));
  regions.push(new Array(1, 'Mississippi', 26));
  regions.push(new Array(1, 'Missouri', 25));
  regions.push(new Array(1, 'Montana', 27));
  regions.push(new Array(7, 'Morelos', 88));
  regions.push(new Array(7, 'Nayarit', 90));
  regions.push(new Array(1, 'Nebraska', 30));
  regions.push(new Array(1, 'Nevada', 35));
  regions.push(new Array(4, 'New Brunswick', 55));
  regions.push(new Array(1, 'New Hampshire', 31));
  regions.push(new Array(1, 'New Jersey', 32));
  regions.push(new Array(1, 'New Mexico', 33));
  regions.push(new Array(2, 'New South Wales', 65));
  regions.push(new Array(1, 'New York', 34));
  regions.push(new Array(4, 'Newfoundland', 54));
  regions.push(new Array(1, 'North Carolina', 28));
  regions.push(new Array(1, 'North Dakota', 29));
  regions.push(new Array(4, 'Northwest Territories', 71));
  regions.push(new Array(4, 'Nova Scotia', 56));
  regions.push(new Array(7, 'Nuevo Le?on', 91));
  regions.push(new Array(4, 'Nunavut', 73));
  regions.push(new Array(7, 'Oaxaca', 92));
  regions.push(new Array(1, 'Ohio', 36));
  regions.push(new Array(1, 'Oklahoma', 37));
  regions.push(new Array(4, 'Ontario', 57));
  regions.push(new Array(1, 'Oregon', 38));
  regions.push(new Array(1, 'Pennsylvania', 39));
  regions.push(new Array(4, 'Prince Edward Island', 58));
  regions.push(new Array(7, 'Puebla', 93));
  regions.push(new Array(1, 'Puerto Rico', 64));
  regions.push(new Array(4, 'Quebec', 59));
  regions.push(new Array(2, 'Queensland', 66));
  regions.push(new Array(7, 'Queretaro', 94));
  regions.push(new Array(7, 'Quintana Roo', 95));
  regions.push(new Array(1, 'Rhode Island', 40));
  regions.push(new Array(7, 'San Luis Potosi', 96));
  regions.push(new Array(4, 'Saskatchewan', 60));
  regions.push(new Array(7, 'Sinaloa', 97));
  regions.push(new Array(7, 'Sonora', 98));
  regions.push(new Array(2, 'South Australia', 67));
  regions.push(new Array(1, 'South Carolina', 41));
  regions.push(new Array(1, 'South Dakota', 61));
  regions.push(new Array(7, 'Tabasco', 99));
  regions.push(new Array(2, 'Tasmania', 68));
  regions.push(new Array(1, 'Tennessee', 42));
  regions.push(new Array(1, 'Texas', 43));
  regions.push(new Array(7, 'Tlaxcala', 100));
  regions.push(new Array(1, 'US Virgin Islands', 63));
  regions.push(new Array(1, 'Utah', 44));
  regions.push(new Array(7, 'Veracruz', 101));
  regions.push(new Array(1, 'Vermont', 46));
  regions.push(new Array(2, 'Victoria', 69));
  regions.push(new Array(1, 'Virginia', 45));
  regions.push(new Array(1, 'Washington', 47));
  regions.push(new Array(1, 'West Virginia', 49));
  regions.push(new Array(2, 'Western Australia', 70));
  regions.push(new Array(1, 'Wisconsin', 48));
  regions.push(new Array(1, 'Wyoming', 50));
  regions.push(new Array(7, 'Yucatan', 102));
  regions.push(new Array(4, 'Yukon', 72));
  regions.push(new Array(7, 'Zacatecas', 103));

function countrySelected(selectedValue) {
  selectedValue = selectedValue || '';
  country_id = $('#address_country_id').val();
  options = $('#address_region_id')[0].options;
  options.length = 1;
  for(var i=0; i<regions.length; i++) {
    var region = regions[i];
    if (region[0] == country_id) {
      options[options.length] = new Option(region[1], region[2]);
      if (selectedValue == region[2]) {
        options.selectedIndex = options.length-1;
      }
    }
  }
  if (options.length == 1) {
    $('#address_region_id_field').hide();
  } else {
    $('#address_region_id_field').show();
  }
}

$(function() { 
  //countrySelected($('address_region_id').value);
  $('#address_country_id').change(countrySelected);
});