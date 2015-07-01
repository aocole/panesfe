var GrowingPanes = {
	done: function() {
		// This is just done so we get an event
		// in panesd. The message doesn't matter, we key off the function name.
		console.info('GrowingPanes done')
	},

	keepAlive: function() {
		// This is just done so we get an event
		// in panesd. The message doesn't matter, we key off the function name.
		console.info('GrowingPanes keepAlive')
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
	},

	_next: function() {
		this._dispatchSlideDataEvent('Next');
	},

	_prev: function() {
		this._dispatchSlideDataEvent('Prev');
	},

	_pause: function() {
		this._dispatchSlideDataEvent('TogglePause');
	},

	_dispatchSlideDataEvent: function(navCommand) {
		console.log(navCommand);
		var ev = new CustomEvent("slide" + navCommand, {
			bubbles: true,
			cancelable: true
		});
		document.dispatchEvent(ev);
	}

}

// Try to disable some things that will hang up the display
window.onbeforeunload = null;
window.onunload = null;

KEYBOARD = {
	ENTER: 13,
	SPACE: 32,
	ARROW_UP: 38,
	ARROW_DOWN: 40,
	ARROW_LEFT: 37,
	ARROW_RIGHT: 39,
	PAGE_UP: 33,
	PAGE_DOWN: 34,
	BACKSPACE: 8,
	HOME: 36,
	END: 35 
}

// Try to cancel any existing key handlers on the page.
if (typeof jQuery !== 'undefined') {
	jQuery(document).off('keyup');
	jQuery(document).off('keydown');
	jQuery(document).off('keypress');
}

document.addEventListener('keyup', function(e) {
	switch(e.keyCode) {
	case KEYBOARD.ARROW_DOWN:
	case KEYBOARD.ARROW_LEFT:
	case KEYBOARD.PAGE_UP:
	case KEYBOARD.BACKSPACE:
		GrowingPanes._prev();
		break;
	case KEYBOARD.ENTER:
	case KEYBOARD.ARROW_RIGHT:
	case KEYBOARD.ARROW_UP:
	case KEYBOARD.PAGE_DOWN:
		GrowingPanes._next();
		break;
	case KEYBOARD.SPACE:
		GrowingPanes._pause();
		break;
	}
	e.preventDefault();
	return false;
});

GrowingPanes.start();

