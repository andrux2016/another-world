<?php
namespace App\Models;

use Phalcon\Mvc\Model;

class News extends Model
{
	public $id;

	public function getSource()
	{
	 	return DB_PREFIX."news";
	}
}

?>