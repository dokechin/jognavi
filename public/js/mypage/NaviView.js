var NaviView = Backbone.View.extend({
    model : Navi,
    template : _.template( '<a href="#" class="list-group-item {{  if (selected == true){ }}active{{ } }}"><i stype="font-size : 20px;" class="{{= icon }} icon icon-3x"></i><br/>{{= title }}</a>'),
    events: {
        'click' : function ( event ) {
            this.detail( event);
        }
    },
	initialize: function() {
        this.listenTo(this.model, 'change', this.render);
	},
	render: function(){
	    var value = this.template( this.model.toJSON());
        this.$el.html(value);
        return this;
	},
	detail: function(event){
        this.model.set("selected", true);
        $(this.model.get("view")).removeClass("hide");
        g_navis.each(function(navi) {
            if (this.model.get("title") != navi.get("title")){
                navi.set("selected" , false);
                $(navi.get("view")).addClass("hide");
            }
        }, this);
	}

});



