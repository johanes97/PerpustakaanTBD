<?php
    class MySQLDB{
        protected $servername = "localhost";
        protected $username = "root";
        protected $password = "";
        protected $dbname = "tugasbesarpbw2";   

        protected $db_connection;
    
        function openConnection(){
            //Create connection
            $this->db_connection = new mysqli($this->servername,$this->username,$this->password,$this->dbname);

            //check connection
            if($this->db_connection->connect_errno){
                echo 'Koneksi gagal';
            }
        }
        
        function getQuery(){
            return $this->db_connection;
        }

        function executeQuery($sql){
            $this->openConnection();
            $query_result=$this->db_connection->query($sql);
            $result=[];
            if($query_result->num_rows>0){
                //output data of each row
                while($row = $query_result->fetch_array()){
                    $result[]=$row;
                }
            }
            //$this->db_connection->close();
            return $result;
        }

        function executeNonQuery($query){
            $this->openConnection();
            if($this->db_connection->query($query)==FALSE){
                echo "Query failed<br>";
            }
            //$this->db_connection->close();
        }

    }
    $conn = new MySQLDB();
    $conn->openConnection();
?>