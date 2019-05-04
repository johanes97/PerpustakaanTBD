<?php

class MySQLDB{
	protected $host = "localhost";
	protected $port = "3306";
	protected $socket   = "";
	protected $user = "root";
	protected $password = "";
	protected $dbname = "perpustakaantbd";   

	protected $db_connection;

	function openConnection(){
		//Create connection
		$this->db_connection = new mysqli($this->host,$this->user,$this->password,$this->dbname,$this->port,$this->socket);

		//check connection
		if($this->db_connection->connect_errno){
			echo 'Koneksi gagal';
		}
	}
	
	function getQuery(){
		return $this->db_connection;
	}

	function executeQuery($sql){
		$query_result=$this->db_connection->query($sql);
		$result=[];
		if(is_object($query_result)){
			if($query_result->num_rows>0){
			//output data of each row
				while($row = $query_result->fetch_array()){
					$result[]=$row;
				}
			}
			return $result;
		}
		else{
			return null;
		}
	
		//$this->db_connection->close();
	}

	function executeNonQuery($query){
		if($this->db_connection->query($query)==FALSE){
			echo "Query failed<br>";
		}
		//$this->db_connection->close();
	}
}

$conn = new MySQLDB();
$conn -> openConnection();