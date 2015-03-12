var GrowingPanes = {
	done: function() {
		// This is just done so we get an event
		// in panesd.
		console.info('GrowingPanes done')
	},

	start: function() {
		this._getJSON();
	},

	_ready: function(slideData) {	
		var ev = this._createSlideDataEvent(slideData);
		document.dispatchEvent(ev);
	},

	_createSlideDataEvent: function(slideData) {
		var ev = new CustomEvent("slideDataReady", {
			detail: {
				slideData: slideData
			},
			bubbles: true,
			cancelable: true
		});
		return ev;
	},

	_getJSON: function() {
		var request = new XMLHttpRequest();
		var self = this;
		request.onload = function(){
			if (request.status >= 200 && request.status < 400) {
				var slideData = JSON.parse(request.responseText);
				self._ready(slideData);
				return;
			}
			else {
				// some server error
				return null;
			}
		}

		request.onerror = function() {
		  // There was a connection error of some sort
		}

		request.open("GET", document.location.href + '.json', true);
		request.send();
	}

}
GrowingPanes.start();
