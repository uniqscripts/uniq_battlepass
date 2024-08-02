let resource = GetParentResourceName();

$(function() {
    $('body').css('display', 'none');
	
	window.addEventListener('message', function(event) {
		if (event.data.enable) {
            $('.steam-nick').text('Hello ' + event.data.info.name + '!');
            $('.steam-image').attr('src', event.data.info.avatar);
			$('body').fadeIn();
		}
	});


    $('.exit-btn').click(function() {
		clearTable();
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


function OpenScoreboard() {
    $.post(`https://${resource}/OpenScoreboard`, JSON.stringify({}), function(response) {
        const tableWrapper = document.querySelector('.table-wrapper');

        tableWrapper.innerHTML = '';

        const data = JSON.parse(response);

        data.sort((a, b) => b.xp - a.xp);

        data.forEach((item, index) => {
            const row = document.createElement('div');
            row.className = 'table-row';

            const rank = document.createElement('h3');
            rank.className = 'table-h3';
            rank.textContent = `#${index + 1}`;
            row.appendChild(rank);

            const userInfo = document.createElement('div');
            userInfo.className = 'table-user-info';
            const userImg = document.createElement('img');
            userImg.className = 'table-steam-img';
            userImg.src = 'img/uniq_logo.png';
            const userName = document.createElement('h3');
            userName.className = 'table-h3';
            userName.textContent = item.name;
            userInfo.appendChild(userImg);
            userInfo.appendChild(userName);
            row.appendChild(userInfo);

            const tier = document.createElement('h3');
            tier.className = 'table-h3';
            tier.textContent = item.tier;
            row.appendChild(tier);

            const xp = document.createElement('h3');
            xp.className = 'table-h3';
            xp.textContent = item.xp.toLocaleString();
            row.appendChild(xp);

            const bp = document.createElement('h3');
            bp.className = 'table-h3';
            bp.id = item.premium === true ? 'table-premium-pass' : '';
            bp.textContent = item.premium === true ? 'Premium' : 'Free';
            row.appendChild(bp);

            const taskdone = document.createElement('h3');
            taskdone.className = 'table-h3';
            taskdone.textContent = item.taskdone;
            row.appendChild(taskdone);

            tableWrapper.appendChild(row);
        });

        const topPlayer = data[0];

        $('.table-user-stats h3.table-h3').first().text('#1');
        $('.table-user-stats .table-user-info.table-steam-img').attr('src', 'img/new_logo.png');
        $('.table-user-stats .table-user-info h3.table-h3').text(topPlayer.name);
        $('.table-user-stats h3.table-h3').eq(2).text(topPlayer.tier);
        $('.table-user-stats h3.table-h3').eq(3).text(topPlayer.xp.toLocaleString());
        $('.table-user-stats h3.table-h3').eq(4).text(topPlayer.premium === true ? 'Premium' : 'Free');
        $('.table-user-stats h3.table-h3').eq(4).attr('id', topPlayer.premium === true ? 'table-premium-pass' : 'table-free-pass' );
        $('.table-user-stats h3.table-h3').last().text(topPlayer.taskdone);
    });
}


function clearTable() {
    const tableWrapper = document.querySelector('.table-wrapper');

	console.log(JSON.stringify(tableWrapper))
    if (tableWrapper) {
        tableWrapper.innerHTML = '';
    }
}