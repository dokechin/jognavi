var EquipmentsView = Backbone.View.extend({
    el: '#equipments_view',
	initialize: function() {
	    this.render();
//	    this.listenTo(this.collection,"request",this.render);
////	    this.listenTo(this.collection,"sync",this.render);
	    this.listenTo(this.collection,"reset",this.render);
	},
    render: function() {
     $('#equipments_view').empty();
      this.collection.each(function(equipment) {
        var equipmentView = new EquipmentView({model: equipment});
        this.$el.append(equipmentView.render().el);
      }, this);
      if (bxslider) {
          bxslider.destroySlider();
          bxslider = $('.bxslider').bxSlider(); 
      }
      else{
          bxslider = $('.bxslider').bxSlider(); 
      }
      return this;
    }

});



