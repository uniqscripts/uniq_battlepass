let resource = GetParentResourceName();

$(function() {
    $('body').css('display', 'none');
	
	window.addEventListener('message', function(event) {
		if (event.data.enable) {
            $('.steam-nick').text(event.data.info.name);
			$('body').fadeIn();
		}
	});


    $('.exit-btn').click(function() {
		$('body').css('display', 'none');
		$.post(`https://${resource}/quit`, JSON.stringify({}));
	});
	
	document.onkeyup = function(event) {
		if (event.key == 'Escape') {
			$('body').css('display', 'none');
			$.post(`https://${resource}/quit`, JSON.stringify({}));
		}
	};
});