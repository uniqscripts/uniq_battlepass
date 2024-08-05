let resource = GetParentResourceName();

$(function() {
    $('body').css('display', 'none');
	
	window.addEventListener('message', function(event) {
		if (event.data.enable) {
            $('.steam-nick').text('Hello ' + event.data.info.name + '!');
            $('.steam-image').attr('src', event.data.info.avatar);
			$('body').fadeIn();
            SetupItems(event.data.items, event.data.path);
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


function SetupItems(items, path) {
    const container = document.querySelector('.free-pass-row');
    container.innerHTML = '';


    for (const key in items) {
        if (items.hasOwnProperty(key)) {
            const item = items[key];

            const rewardBoxWrapper = document.createElement('div');
            rewardBoxWrapper.className = 'reward-box-wrapper';

            const rewardBox = document.createElement('div');
            rewardBox.className = 'reward-box';

            const overlay = document.createElement('div');
            overlay.className = 'overlay';

            const xpLabel = document.createElement('div');
            xpLabel.className = 'unlock-tier-btn';
            xpLabel.innerHTML = `Requires ${item.requiredXP} XP`;

            overlay.appendChild(xpLabel);

            const img = document.createElement('img');
            img.className = 'item-image';
            img.src = path.replace('%s', item.img ? item.img : item.name);

            const h3 = document.createElement('h3');
            h3.className = 'item-name';
            h3.textContent = item.label;


            const h4 = document.createElement('h4');
            h4.className = 'item-count';
            h4.textContent = item.amount + 'x';

            rewardBox.appendChild(overlay);
            rewardBox.appendChild(img);
            rewardBox.appendChild(h3);
            rewardBox.appendChild(h4);

            rewardBoxWrapper.appendChild(rewardBox);

            container.appendChild(rewardBoxWrapper);
        }
    }
}

function OpenScoreboard() {
    $.post(`https://${resource}/OpenScoreboard`, JSON.stringify({}), function(response) {
        const tableWrapper = document.querySelector('.table-wrapper');

        tableWrapper.innerHTML = '';

        response.sort((a, b) => b.xp - a.xp);

        response.forEach((item, index) => {
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
            userImg.src = item.avatar;
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

        const topPlayer = response[0];

        if (topPlayer) {
            $('.table-user-stats h3.table-h3').first().text('#1');
            $('.table-user-stats .table-user-info .table-steam-img').attr('src', topPlayer.avatar);
            $('.table-user-stats .table-user-info h3.table-h3').text(topPlayer.name);
            $('.table-user-stats h3.table-h3').eq(2).text(topPlayer.tier);
            $('.table-user-stats h3.table-h3').eq(3).text(topPlayer.xp.toLocaleString());
            $('.table-user-stats h3.table-h3').eq(4).text(topPlayer.premium === true ? 'Premium' : 'Free');
            $('.table-user-stats h3.table-h3').eq(4).attr('id', topPlayer.premium === true ? 'table-premium-pass' : 'table-free-pass' );
            $('.table-user-stats h3.table-h3').last().text(topPlayer.taskdone);
        }
    });
}


function clearTable() {
    const tableWrapper = document.querySelector('.table-wrapper');

	console.log(JSON.stringify(tableWrapper))
    if (tableWrapper) {
        tableWrapper.innerHTML = '';
    }
}