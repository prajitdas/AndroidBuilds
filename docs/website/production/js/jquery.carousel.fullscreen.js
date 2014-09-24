/******************************************************************************
	Transforms the basic Twitter Bootstrap Carousel into Fullscreen Mode
	@author Fabio Mangolini
     http://www.responsivewebmobile.com
******************************************************************************/
jQuery(document).ready(function() {
	$('.carousel').carousel({
    	pause: "true",
    	interval: 200000000000000
	});

	$('.carousel').css({'margin': 0, 'width': $(window).outerWidth(), 'height': $(window).outerHeight()});
	$('.carousel .item').css({'position': 'fixed', 'width': '100%', 'height': '100%'});
	$('.carousel-inner div.item img').each(function() {
		if($(this).attr('id')!='donottouch'){
			var imgSrc = $(this).attr('src');
			$(this).parent().css({'background': 'url('+imgSrc+') center center no-repeat', '-webkit-background-size': '100% ', '-moz-background-size': '100%', '-o-background-size': '100%', 'background-size': '100%', '-webkit-background-size': 'cover', '-moz-background-size': 'cover', '-o-background-size': 'cover', 'background-size': 'cover'});
			$(this).remove();
		}
	});

	$(window).on('resize', function() {
		$('.carousel').css({'width': $(window).outerWidth(), 'height': $(window).outerHeight()});
	});
});

$('.navbar li').click(function(e) {
	var $this = $(this);
	if ($this.hasClass('activable')) {
		$('.navbar li.active').removeClass('active');
		var $this = $(this);
		if (!$this.hasClass('active')) {
			$this.addClass('active');
		}
		/*e.preventDefault();*/
	}
		
	});
	

	
