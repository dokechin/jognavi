var AddressInputView = Backbone.View.extend({

	initialize: function(el) {

        this.el = el;
        this.geocoder = new google.maps.Geocoder();

	},
	
    events: {
        "click":          "search",
    },

	search: function() {

      var address = $('#addresst').val();
      this.geocoder.geocode({"address": address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          global_map.setCenter(results[0].geometry.location);
        } else {}
      });

	}

});


