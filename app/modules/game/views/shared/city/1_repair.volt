<? $this->view->partial('shared/city_header', Array('title' => 'Кузница', 'credits' => $this->user->credits)); ?>

<div class="textblock">
	<div class="row">
		<div class="col-xs-12 text-xs-right">
			<a href="<?=$this->url->get('map/') ?>?otdel=<?=$otdel ?>"><img src='/images/images/refresh.gif' alt='Обновить'></a>
			<a href="<?=$this->url->get('map/') ?>?refer=11"><img src='/images/images/back.gif' alt='Вернуться'></a>
		</div>
	</div>
	<div class="clearfix"></div>

	<? if ($this->user->r_time > time()): ?>
		<script src='/img/js/time.js'></script>
		<center>
			<table cellspacing=0 cellpadding=3>
				<tr>
					<td><font color=red><b>Оставшееся время:</b></font></td>
					<td id=know style='COLOR: red; FONT-WEIGHT: Bold; TEXT-DECORATION: Underline'></td>
				</tr>
			</table>
		</center>
		<script>ShowTime('know', "<?=($this->user->r_time - time()) ?>");</script>
	<? endif; ?>

	<? if (!empty($message)): ?>
		<p class="message bg-danger"><?=$message ?></p>
	<? endif; ?>

	<ul class="nav nav-tabs">
		<li role="presentation" class="<?=($otdel == 1 ? 'active' : '') ?>"><a href="<?=$this->url->get('map/') ?>?otdel=1">Починка вещей</a></li>
		<? if ($this->user->proff == 3): ?>
	 		<li role="presentation" class="<?=($otdel == 2 ? 'active' : '') ?>"><a href="<?=$this->url->get('map/') ?>?otdel=2">Огранка камней</a></li>
		<? endif; ?>
	  	<li role="presentation" class="<?=($otdel == 3 ? 'active' : '') ?>"><a href="<?=$this->url->get('map/') ?>?otdel=3">Гравировка и модернизация вещей</a></li>
		<? if ($this->user->proff == 2): ?>
			<li role="presentation" class="<?=($otdel == 4 ? 'active' : '') ?>"><a href="<?=$this->url->get('map/') ?>?otdel=4">Кузнечное дело</a></li>
		<? endif; ?>
	</ul>

	<div class="tab-content">
		<div class="tab-pane fade in active">
			<? if ($otdel > 0 && isset($objects)): ?>
				<? if ($otdel == 1): ?>
					<? $this->view->partial('shared/city/repair/repair', Array('objects' => $objects)); ?>
				<? elseif ($otdel == 2): ?>
					<? $this->view->partial('shared/city/repair/cut', Array('objects' => $objects)); ?>
				<? elseif ($otdel == 3): ?>
					<? $this->view->partial('shared/city/repair/etching', Array('objects' => $objects)); ?>
				<? elseif ($otdel == 4): ?>
					<? $this->view->partial('shared/city/repair/insert', Array('objects' => $objects, 'weapons' => $weapons)); ?>
				<? endif; ?>
			<? endif; ?>
		</div>
	</div>
	<div class="clearfix"></div>
</div>