var MyEquipment = Backbone.Model.extend({
  initialize: function () {
      Backbone.Model.prototype.initialize.apply(this, arguments);
      this.on("change", function (model, options) {
            if (options && options.save === false) return;
            model.save();
      });
  },
  defaults:{
  name: "",
  user_id: "",
  url: "",
  img: "",
  price: 0,
  store_url: "",
  store_name: "",
  bought_at : "2013-01-01",
  polish_at : "2013-01-01",
  distance : 0
  }
});
