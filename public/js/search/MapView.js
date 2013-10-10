var MapView = Backbone.View.extend({

	initialize: function() {

        var self = this;

        google.maps.event.addListener( this.model, 'idle', function (){
            self.refleshMarker(this.getBounds());
        });


	},
    refleshMarker : function(bounds){

        var start_marker;
        var start_icon = "/img/start-race.png";
        var finish_icon = "/img/finish2.png";
        var startfinish_icon = "/img/startfinish.png";

        var startimg = new google.maps.MarkerImage(start_icon,
              new google.maps.Size(32, 37),
              new google.maps.Point(0, 0),
              new google.maps.Point(16, 37)
        );

        var finishimg = new google.maps.MarkerImage(finish_icon,
              new google.maps.Size(32, 37),
              new google.maps.Point(0, 0),
              new google.maps.Point(16, 37)
        );

        var startfinishimg = new google.maps.MarkerImage(startfinish_icon,
               new google.maps.Size(32, 37),
               new google.maps.Point(0, 0),
               new google.maps.Point(16, 37)
        );


        var northEastLatLng = bounds.getNorthEast();
        var southWestLatLng = bounds.getSouthWest();

        //jsonファイルの取得
        $.ajax({
          url: '/search/routes',
          type: 'POST',
          data : {
            neLat : northEastLatLng.lat(),
            neLng : northEastLatLng.lng(),
            swLat : southWestLatLng.lat(),
            swLng : southWestLatLng.lng(),
            seLat : southWestLatLng.lat(),
            seLng : northEastLatLng.lng(),
            nwLat : northEastLatLng.lat(),
            nwLng : southWestLatLng.lng()
          },
          dataType: 'json',
          timeout: 10000,
          error: function(){
            alert("地図データの読み込みに失敗しました");
          },
          success: function(json){
              var models = [];
              //帰ってきた地点の数だけループ
              for (var i = 0; i < json.length; i++){

                var path = [];

                for (var j = 0; j < json[i].path.length; j++) {
                  var latlng = new google.maps.LatLng(json[i].path[j][0], json[i].path[j][1]);
                  path.push (latlng);
                }

                poly = new MyPolyline({ map: global_map,  strokeColor: json[i].route_color});

                poly.setPath(path);
                poly.setName(json[i].name);

                if (path[0].equals(path[path.length-1])){
                  startfinish_marker = new google.maps.Marker({position: path[0], map: global_map, title: json[i].name, icon: startfinishimg});
                }
                else{
                  start_marker = new google.maps.Marker({position: path[0], map: global_map, title: json[i].name, icon: startimg});
                  finish_marker = new google.maps.Marker({position: path[path.length-1], map: global_map, title: "finish", icon: finishimg});
                }

                google.maps.event.addListener(poly, "click", function(evt) {
                    alert(this.getName());
                });
                
                var hash = {id: json[i].id, name: json[i].name,route_color:json[i].route_color, distance:json[i].distance};
                if (typeof json[i].mycourse  != 'undefined'){
                    hash.mycourse = json[i].mycourse;
                }
                models.push(hash);

              }
              global_routes.reset(models);
          }
        });
    }
});



