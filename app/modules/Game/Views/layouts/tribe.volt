<?
$uri=GetEnv("REQUEST_URI");
$uri=explode("?",$uri);
$uri=$uri['0'];

$usemagic = $_POST['usemagic'];
$useid = $_POST['useid'];
$login = $_POST['login'];
$mode = $_GET['mode'];
$money = $_POST['money'];
$klan_mode = intval($_GET['klan_mode']);

if (($set == "clan" && $uri=="/main.php") && (!empty($_POST['usemagic']) && is_numeric($_POST['useid']))) include("includes/magic/abils/use.php");

print"<table width=100% cellspacing=0 cellpadding=5 border=0>
<tr>
<TD width=1>&nbsp;</TD>
<td width=600 valign=top>


<TABLE cellspacing=0 cellpadding=0>
<tr>

<TD valign=top>
<SCRIPT language=JavaScript>
show_inf('$stat[user]','$stat[id]','$stat[level]','$stat[rank]','$stat[tribe]');
</SCRIPT>
</TD>

<TD WIDTH=10>&nbsp;</TD>


<TD WIDTH=5>&nbsp;</TD>


</TR>
</TABLE>

</td>

<td align=right valign=top>
<img src='img/images/refresh.gif' style='CURSOR: Hand' alt='Обновить' onclick='window.location.href=\"main.php?set=clan&tmp=\"+Math.random();\"\"'>

<img src='img/images/back.gif' style='CURSOR: Hand' alt='Вернуться' onclick='window.location.href=\"main.php?tmp=\"+Math.random();\"\"'>
</td>
</tr>
</table>";


if ($stat['tribe']) {

        function ld_m ($t,$u,$w,$r,$m,$s) {
                global $now;
                mysql_query("INSERT INTO ld (user, writer, mess, time, reason, type, srok) values('".addslashes($u)."', '".addslashes($w)."', '".addslashes($m)."', '".$now."', '".addslashes($r)."', '".addslashes($t)."', '".addslashes($s)."')");
        }

        // Принятие в клан
        if ($mode == "add" && ($stat['b_tribe'] > 0 || $stat['tribe_rank'] == 5)) {
                if (empty($login) || $login == "Логин")
                        $msg = "Укажите логин персонажа, которого Вы хотите принять в клан!";
                else {
                        $hinfo=mysql_fetch_array(mysql_query("SELECT user, id, room, rank, level, tribe, ic FROM person WHERE user='".addslashes($login)."' LIMIT 1"));
			$STK=mysql_num_rows(mysql_query("SELECT tribe FROM person WHERE tribe='".$stat['tribe']."'"));
			$ostk=$STK*200;
                        if (empty($hinfo['user']))
                                $msg = "Персонаж <u>".$login."</u> не найден!";
                        elseif ($hinfo['user'] == $stat['user'])
                                $msg = "Вы и так состоите в клане <U>".$stat['tribe']."</U>!";
                        elseif ($hinfo['tribe'])
                                $msg = "Персонаж <U>".$hinfo['user']."</U> состоит в клане <U>".$hinfo['tribe']."</U>.";
                        elseif ($hinfo['rank'] > 99)
                                $msg = "Вы не можете принимать в клан должностных лиц!";
                        elseif ($hinfo['level'] < 4)
                                $msg = "Вступать в клан могут персонажи не ниже 4 уровня!";
			   elseif ($clan['kazna'] < $ostk)
                                $msg = "В казне клана нету ".$ostk." кредитов!";
                        elseif ($hinfo['ic'] < $now)
                                $msg = "Персонаж либо слишком давно проходил проверку у Инквизиторов, либо не проходил её вовсе!";
                        else {
		if ($clan['sclon'] == 1 || $clan['sclon'] == 2 || $clan['sclon'] == 3){
                                $RunQuery = mysql_query("UPDATE person SET tribe='".$stat['tribe']."', sclon='".$clan['sclon']."', b_tribe=0, tribe_rank='' WHERE user='".$hinfo['user']."'");
                                mysql_query("UPDATE tribes SET kazna=kazna-'".$ostk."' WHERE name='".$stat['tribe']."'"); $clan['kazna']=$clan['kazna']-$ostk;
		}else{
                                $RunQuery = mysql_query("UPDATE person SET tribe='".$stat['tribe']."', b_tribe=0, tribe_rank='' WHERE user='".$hinfo['user']."'");
                                mysql_query("UPDATE tribes SET kazna=kazna-'".$ostk."' WHERE name='".$stat['tribe']."'"); $clan['kazna']=$clan['kazna']-$ostk; }
                                if ($RunQuery) {

                                        ld_m (4,$hinfo['user'],'Администратор','',"Принят в клан <U>".$stat['tribe']."</U> персонажем <U>".$stat['user']."</U>",'');

                                        require_once("function/chat_insert.php");
                                        insert_msg("Персонаж <b><u>".$stat['user']."</u></b> принял Вас в клан <b><u>".$stat['tribe']."</u></b>","","","1",$hinfo['user'],"",$hinfo['room']);

                                        $msg = "Вы приняли в клан персонажа <U>".$hinfo['user']."</U> за <U>".$ostk."</U> кр.";
                                }
                        }
                }
        }

        // Исключение из клана
        if ($mode == "drop" && ($stat['b_tribe'] > 0 || $stat['tribe_rank'] == 5)) {
                if (empty($login) || $login == "Логин")
                        $msg = "Укажите логин персонажа, которого Вы хотите принять в клан!";
                else {
                        $hinfo=mysql_fetch_array(mysql_query("SELECT user, id, room, tribe, b_tribe, ic FROM person WHERE user='".addslashes($login)."' LIMIT 1"));

                        if (empty($hinfo['user']))
                                $msg = "Персонаж <u>".$login."</u> не найден!";
                        elseif ($hinfo['user'] == $stat['user'])
                                $msg = "Вы не можете исключить из клана самого себя!";
                        elseif ($hinfo['tribe'] != $stat['tribe'])
                                $msg = "Персонаж <U>".$hinfo['user']."</U> не состоит в вашем клане!";
                        elseif ($hinfo['ic'] < $now)
                                $msg = "Персонаж либо слишком давно проходил проверку у Инквизиторов, либо не проходил её вовсе!";
                        elseif ($hinfo['b_tribe'] == 1)
                                $msg = "Персонаж <U>".$hinfo['user']."</U> является главой клана ".$stat['tribe'].".<BR>Никто не в праве исключить главу клана!";
                        else {
		if ($clan['sclon'] == 1 || $clan['sclon'] == 2 || $clan['sclon'] == 3)
                                $RunQuery = mysql_query("UPDATE person t1, person t2 SET t2.tribe='', t2.sclon=0, t2.b_tribe=0, t2.tribe_rank='' WHERE t1.user='".$stat['user']."' AND t2.user='".$hinfo['user']."'");
		else
                                $RunQuery = mysql_query("UPDATE person t1, person t2 SET t2.tribe='', t2.b_tribe=0, t2.tribe_rank='' WHERE t1.user='".$stat['user']."' AND t2.user='".$hinfo['user']."'");

                                if ($RunQuery) {

                                        ld_m (4,$hinfo['user'],'Администратор','',"Исключён из клана <U>".$stat['tribe']."</U> персонажем <U>".$stat['user']."</U>",'');

                                        require_once("function/chat_insert.php");
                                        insert_msg("Персонаж <b><u>".$stat['user']."</u></b> исключил Вас из клана <b><u>".$stat['tribe']."</u></b>","","","1",$hinfo['user'],"",$hinfo['room']);

                                        $msg = "Вы исключили из клана персонажа <U>".$hinfo['user']."</U>.";
                                }
                        }
                }
        }

        // Сложение полномочий
        if ($mode == "tcp" && $stat['b_tribe'] == 1) {
                if (empty($login) || $login == "Логин")
                        $msg = "Укажите логин персонажа, на которого Вы хотите сложить полномочия!";
                else {
                        $hinfo=mysql_fetch_array(mysql_query("SELECT user, id, room, tribe, b_tribe FROM person WHERE user='".addslashes($login)."' LIMIT 1"));

                        if (empty($hinfo['user']))
                                $msg = "Персонаж <u>".$login."</u> не найден!";
                        elseif ($stat['b_tribe'] != 1)
                                $msg = "У Вас нет полномочий, что бы их складывать! :)";
                        elseif ($hinfo['user'] == $stat['user'])
                                $msg = "Зачем складывать полномочия на самого себя? :)";
                        elseif ($hinfo['tribe'] != $stat['tribe'])
                                $msg = "Персонаж <U>".$hinfo['user']."</U> не состоит в Вашем клане!";
                        else {
                                $RunQuery = mysql_query("UPDATE person t1, person t2 SET t1.b_tribe=0, t2.b_tribe=1, t2.tribe_rank='' WHERE t1.user='".$stat['user']."' AND t2.user='".$hinfo['user']."'");
                                $stat['b_tribe'] = 0;

                                if ($RunQuery) {
                                        require_once("function/chat_insert.php");
                                        insert_msg("Персонаж <b><u>".$stat['user']."</u></b> сложил на Вас полномочия главы клана <b><u>".$stat['tribe']."</u></b>","","","1",$hinfo['user'],"",$hinfo['room']);

                                        $msg = "Вы сложили полномочия на персонажа <U>".$hinfo['user']."</U>.";
                                }
                        }
                }
        }


echo"

<table width=100% cellspacing=0 cellpadding=3 border=0>
<tr>
<td align=right>
<center><font class=title>Клан <U>".$clan['name_short']."</U></font></center><br>

<fieldset style='WIDTH: 98.6%'><legend>Состав клана</legend>
<table width=100% cellspacing=0 cellpadding=5>
<tr>
<td align=center>

<table cellspacing=0 cellpadding=0 border=0 width=100%>
<tr>";



if ($stat['tribe_rank'] >= 0 || $stat['b_tribe'] == 1) {
echo"
<TD width=185 align=center valign=top>

<table cellspacing=0 cellpadding=5 style='border-style: outset; border-width: 2' border=1 width=180>
<tr>
<td align=center>

<b>Управление</b><HR color=silver>
Казна клана: <b>".$clan['kazna']."</b> кр.
<HR color=silver>";
echo"<input type=button value='Артефакты клана' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"top.main.location='../main.php?set=clan&klan_mode=1';\"><HR color=Silver width=159>";

if ($stat['b_tribe'] == 1)
	echo"<input type=button value='Редактирование клана' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"top.main.location='../main.php?set=clan&klan_mode=2';\"><HR color=Silver width=159>";

if ($stat['b_tribe'] == 1 || $stat['tribe_rank'] == 5) echo"<input type=button value='Принять в клан' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"ShowForm('Принять в клан', 'main.php?set=clan&mode=add','','');\" onmouseover=\"hint('Принять в клан персонажа. Деньги снимаються с того кто принимает, т.е. с главы клана.');\" onmouseout=\"c();\"><HR color=Silver width=159>";

if ($stat['b_tribe'] == 1 || $stat['tribe_rank'] == 5) echo"<input type=button value='Исключить из клана' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"ShowForm('Исключить из клана', 'main.php?set=clan&mode=drop','','');\" onmouseover=\"hint('Исключить из клана персонажа');\" onmouseout=\"c();\"><HR color=Silver width=159>";

if ($stat['b_tribe'] == 1 || $stat['tribe_rank'] == 5) echo"<input type=button value='Редактировать статус' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"cl_stat();\" onmouseover=\"hint('Редактировать статус персонажа, состоящего в Вашем клане');\" onmouseout=\"c();\"><HR color=Silver width=159>";

if ($stat['b_tribe'] == 1 || $stat['tribe_rank'] == 3 || $stat['tribe_rank'] == 2){
 echo"<input type=button value='Взять из казны' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"give_money();\" onmouseover=\"hint('Взять деньги из казны вашего клана');\" onmouseout=\"c();\"><HR color=Silver width=159>";
 echo"<input type=button value='Лог передач' class=input style='WIDTH: 150px; CURSOR: Hand' onclick='window.open(\"tribe_logs.php?clan=$stat[tribe]\",\"\",\"width=400,height=200,noresizable\");' onmouseover=\"hint('Последние 50 передач казны');\" onmouseout=\"c();\"><HR color=Silver width=159>";
}
echo"<input type=button value='Положить в казну' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"add_money();\" onmouseover=\"hint('Положить деньги в казну вашего клана');\" onmouseout=\"c();\">";

if ($stat['b_tribe'] == 1)
        echo"<HR color=Silver width=159><input type=button value='Сложить полномочия' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"ShowForm('Сложить полномочия', 'main.php?set=clan&mode=tcp','','');\" onmouseover=\"hint('Сложить с себя полномочия <b>главы клана</b> на другого персонажа');\" onmouseout=\"c();\">";

echo"</td>
</tr>
</table></td>";
}

echo"<td align=center valign=top>";

echo"<div id=form></div>
<div id=mainform></div>";




        // Редактирование статуса
        if ($mode=="edit" && ($stat['b_tribe'] > 0 || $stat['tribe_rank'] == 5)) {
                if (empty($login) || $login == "Логин")
                        $msg = "Укажите логин персонажа, статус которого вы хотите изменить!";
                else {
                        $hinfo=mysql_fetch_array(mysql_query("SELECT user, tribe, b_tribe, tribe_rank FROM person WHERE user='".addslashes($login)."' LIMIT 1"));

                        if (empty($hinfo['user']))
                                $msg = "Персонаж <u>".$login."</u> не найден!";
                        elseif ($hinfo['tribe'] != $stat['tribe'])
                                $msg = "Персонаж <U>".$hinfo['user']."</U> не состоит в вашем клане!";
	        elseif ($stat['b_tribe'] != 1 && $stat['tribe_rank'] != 5)
		$msg = "Нет доступа к данной функции!";
                        elseif ($hinfo['b_tribe'] == 1)
                                $msg = "Персонаж <U>".$hinfo['user']."</U> является главой клана ".$stat['tribe'].".<BR>Никто не в праве изменить статус главы клана!";
                        else {

                                        mysql_query("UPDATE person SET tribe_rank='".addslashes($_POST['addstatus'])."' WHERE user='".addslashes($login)."'");

                                        $msg="Статус персонажа <U>".$hinfo['user']."</U> успешно изменён!";
                        }
                }
        }

        // казна
        if ($mode=="addmoney") {
                if (empty($money) || $money == "Сумма")
                        $msg = "Укажите сумму, которую желаете перечислить на клановый счёт!";
                else {
		$money = str_replace(',','.',$money);
                        if (!eregi("^[0-9_\.\,\ ]+$",$money))
                                $msg = "Некорректно задано число!";
                        elseif ($stat['credits'] < $money)
                                $msg = "Недостаточно кредитов!";
                        else {
		        mysql_query("INSERT INTO tribe_log (time, user, tribe, action) values('$now', '$stat[user]','$stat[tribe]', 'Перевел в казну $money кр.')");
                                        mysql_query("UPDATE person SET credits=credits-'".addslashes($money)."' WHERE user='".$stat['user']."'");
		        mysql_query("UPDATE tribes SET kazna=kazna+'".addslashes($money)."' WHERE name='".$stat['tribe']."'");
		        $clan['kazna']+=$money;
                                        $msg="Вы успешно перечислили сумму <U>".$money."</U> кр. в казну клана!";
                        }
                }
        }
        if ($mode=="givemoney") {
                if (empty($money) || $money == "Сумма")
                        $msg = "Укажите сумму, которую желаете снять с  кланового счёта!";
                else {
		$money = str_replace(',','.',$money);
                        if (!eregi("^[0-9_\.\,\ ]+$",$money))
                                $msg = "Некорректно задано число!";
                        elseif ($clan['kazna'] < $money)
                                $msg = "Недостаточно кредитов!";
	        	   elseif ($stat['b_tribe'] == 0 AND $stat['tribe_rank'] > 3)
					$msg = "Нет доступа к данной функции!";
                        else {
		        mysql_query("INSERT INTO tribe_log (time, user, tribe, action) values('$now', '$stat[user]','$stat[tribe]', 'Взял из казны $money кр.')");
                      mysql_query("UPDATE person SET credits=credits+'".addslashes($money)."' WHERE user='".$stat['user']."'");
		        mysql_query("UPDATE tribes SET kazna=kazna-'".addslashes($money)."' WHERE name='".$stat['tribe']."'");
		        $clan['kazna']-=$money;
                                        $msg="Вы успешно сняли сумму <U>".$money."</U> кр. с казны клана!";
                        }
                }
        }

        if (!empty($msg)) echo"<center><font color=red><b>".$msg."</b></font></center><br>";

	switch ($klan_mode) {

		case 1:
			$ClanArts = mysql_query("SELECT * FROM objects WHERE tribe = '".$stat['tribe']."'");

			$shop_kol = 0;

			echo"<table width=100% border=0 cellspacing=0 cellpadding=0><td>";

			while($objects = mysql_fetch_assoc($ClanArts)) {
				$shop_kol += 1;

			                $obj_inf	= explode("|",$objects['inf']);
			                $obj_min	= explode("|",$objects['min']);

			                include('includes/items/min_tr.php');
			                include('includes/items/add.php');
			                include('includes/items/classes.php');

				echo"<div align='center' >
				<table border='1' background='../img/design/inman/inman_fon2.gif' cellpadding='0' cellspacing='0' style='padding:5; border-collapse: collapse' bordercolor='#D8C792' width='100%'>
				<tr><td width='30%' align='center'><img src='../img/items/".$obj_inf['0'].".gif' alt='".$obj_inf['1']."'><br>";

				echo"</td><td width='70%'><small><b>".$obj_inf['1']."</b><br>Гос. цена: <b>".$obj_inf['2']."</b> кр.<br>Долговечность предмета: <b>".$obj_inf['6']."</b>/<b>".$obj_inf['7']."</b><br>Тип предмета: <i>".$tip."</i><br>";

				if ($min_level || $min_str || $min_dex || $min_ag || $min_vit || $min_razum || $min_proff)
					echo"<br><small><b><i>Минимальные требования:</i></b><br>$min_level$min_str$min_dex$min_ag$min_vit$min_razum$min_proff</small>";

				if ($hp || $energy || $min || $max || $strength || $dex || $agility || $vitality || $razum || $br1 || $br2 || $br5 || $br3 || $br4 || $krit || $mkrit || $unkrit || $uv || $unuv || $pblock)
					echo"<br><small><b><i>Действие предмета:</i></b><br>$hp$energy$min$max$strength$dex$agility$vitality$razum$br1$br2$br5$br3$br4$krit$mkrit$unkrit$uv$unuv$pblock</small>";

					if ($objects['about']) echo"<br><small><b><i>Дополнительная информация:</i></b><br>".$objects['about']."</small>";

					if ($objects['sclon'] == 1)
						echo"<br><small><b><i>Предмет могут носить только Светлые</i></b></small>";
					if ($objects['sclon'] == 2)
						echo"<br><small><b><i>Предмет могут носить только Тёмные</i></b></small>";
					if (!empty($objects['tribe']))
						echo"<br><small><i>Предмет находится у игрока </i><b>".$objects['user']."</b></small>";

				echo"</small></td></tr></table></div><br>";

			}
			if ($shop_kol == 0) echo"<center>У клана нет клановых артефактов.</center></td></table>";
			else echo"</td></table>";

		break;

		case 2:

			if ($_POST && $stat['b_tribe'] == 1) {
				$about 	= htmlspecialchars($_POST['about']);
				$law 	= htmlspecialchars($_POST['law']);
				$url 	= htmlspecialchars($_POST['url']);

				$turl = $url;
				$url = explode("http://", $url);
				if ($url[1] == "" && $turl != "http://") $url = "http://$turl";
				else $url = $turl;

				mysql_query("UPDATE tribes SET about = '".$about."', law = '".$law."', url = '".$url."' WHERE name = '".$stat['tribe']."'");

				$clan['law'] = $law;
				$clan['about'] = $about;
				$clan['url'] = $url;
			}

			echo"<form method=post action=?set=clan&klan_mode=2><table width=100% border=0 cellspacing=0 cellpadding=0>";

			echo"<tr><td width=40% align=center><b>Информация о клане:</b></td><td align=center><textarea name=about rows=6 cols=40>".$clan['about']."</textarea></td></tr>";
			echo"<tr><td width=40% align=center><b>Законы клана:</b></td><td align=center><textarea name=law rows=6 cols=40>".$clan['law']."</textarea></td></tr>";
			echo"<tr><td width=40% align=center><b>URL:</b></td><td align=center><input type=text name=url size=53 value=\"".$clan['url']."\"></td></tr>";
			echo"<tr><td colspan=2 align=center><br><input type=submit value='       Сохранить изменения        '  class=standbut></td></tr>";

			echo"</table></form>";
		break;

		default :
			$SostQuery = mysql_query("SELECT user, id, level, tribe, b_tribe, tribe_rank, rank, sclon, lpv FROM person WHERE tribe='".$stat['tribe']."' ORDER BY user");

			echo"<table cellspacing=0 cellpadding=5 style='border-style: outset; border-width: 2' border=1 width=98%>
			<tr><td width=20 align=center valign=center>Статус</td><td width=250 align=center>Логин персонажа</td><td>Ранг в клане</td></tr>";
			echo"<SCRIPT language=JavaScript>
			function s (user,id,level,rank,sclon,tribe,status,st) {
				if (status == 0)
				        status='<img src=\'img/images/offline.gif\' alt=\'OffLine\' width=15>';
				else
				        status='<img src=\'img/images/online.gif\' alt=\'OnLine\' width=15>';
				document.write('<tr><td width=20 align=center valign=center>'+status+'</td><td width=250><a href=\"javascript:top.pp(\''+user+'\')\"><img src=\'img/images/chat/private.gif\' border=0 alt=\'Приватное сообщение\'></a> <img src=\'img/rank/'+rank+'.gif\'><img src=\'img/images/chat/'+sclon+'.gif\'><img src=\'img/klan/'+tribe+'.gif\' width=24 height=14><a href=\"javascript:top.to(\''+user+'\')\"><b>'+user+'</b></a> ['+level+'] <a href=\'inf.php?'+id+'\' target=_blank border=0><img src=\'img/images/inf.gif\'></a></td><td><b>'+st+'</b></td></tr>');
			}";
			$sostkol = 0;
			for ($j=0; $j<mysql_num_rows($SostQuery); $j++) {
				$sostkol++;
			       	$sostav=mysql_fetch_array($SostQuery);

				switch($sostav['tribe_rank']) {
					case "1": $st="Глава";break;
					case "2": $st="Зам. главы";break;
					case "3": $st="Казначей";break;
					case "4": $st="Оружейник";break;
					case "5": $st="Вербовщик";break;
					case "6": $st="Командир группы";break;
					case "7": $st="Судья";break;
					case "8": $st="Леди";break;
					case "9": $st="Дипломат";break;
					case "10": $st="Журналист";break;
					case "11": $st="Шут";break;
					default: $st="Боец";break;
				}

			        if (time() - $sostav['lpv'] > 180)
			                $status = 0;
			        else
			                $status = 1;
			        echo"s('".$sostav['user']."','".$sostav['id']."','".$sostav['level']."','".$sostav['rank']."','".$sostav['sclon']."','".$sostav['tribe']."','".$status."','".$st."');";
			}
			echo"</script>
			<tr><td colspan=3 align=center>В клане: <b>".$sostkol."</b> человек<br>
			Принятие в клан следующего человека обойдется вам в <b>200*".$sostkol."=".($sostkol*200)."</b> кредитов.</td></tr></table>";

		break;
	}


echo"</td>

<!-- Абилки -->

<TD width=185 align=center valign=top>

<table cellspacing=0 cellpadding=5 style='border-style: outset; border-width: 2' border=1 width=180>
<tr>
<td align=center>

<b>Реликты клана</b>";


$Abils = mysql_query("SELECT abils.*, items.name, items.title FROM abils, items WHERE abils.tribe='".$stat['tribe']."' AND items.name=abils.name ORDER BY abils.id");

if (mysql_num_rows($Abils)) {
        for ($i=0; $i<mysql_num_rows($Abils); $i++) {
                $Abil = mysql_fetch_array($Abils);
                echo"<HR color=Silver width=159><input type=button value='".$Abil['title']."' class=input style='WIDTH: 150px; CURSOR: Hand' onclick=\"javascript: ShowForm('".$Abil['title']."','','','','1','".$Abil['name']."','".$Abil['id']."','0');\" title=\"Оставшийся лимит: ",$Abil['m_iznos']-$Abil['c_iznos']," [".$Abil['m_iznos']."]\">";

        }
}
else
        echo"<HR color=Silver width=159><a class=agree>У Вашего клана нет реликтов!</a>";



echo"</td>
</tr>
</table>

</td>

<!-- Конец абилок -->



</tr>
</table>

</td>
</tr>
</table>
</fieldset>
<BR><BR>

</td>
</tr>
</table>
";


}
else
        echo"<center><b><font color=red>Вы не состоите ни в каком клане!</font></b></center>";