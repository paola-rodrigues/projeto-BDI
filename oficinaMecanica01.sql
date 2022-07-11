/*  Para saber as base de dados comando show databases */
show databases;

create database oficinaMecanica;
use oficinaMecanica;
/*drop database oficinaMecanica;*/
/*SQL -DDL*/
/*1*/
create table cliente(
	cpf varchar(14) primary key not null,
    nome varchar(25) not null,
    email varchar(45) unique
);
/*drop table cliente;*/
desc cliente;
/*2*/
create table veiculo(
	idVeiculo int primary key not null auto_increment,    
    placa varchar(8) not null,
    modelo varchar(45) not null,
    ano year(4) not null unique,
    descricao varchar(45),
    marca varchar(45) not null,
    cliente_cpf varchar(14) not null,
    foreign key(cliente_cpf) references cliente(cpf) on update cascade on delete cascade
);

desc veiculo;
/*3*/
create table mecanico(
	cpf varchar(14) primary key not null,
    nome varchar(60) not null,
    salario decimal(6,2) not null,
    especialidade varchar(45) not null,
    sexo char(1) not null,
    dataNasc date not null,
    ctps varchar(20) not null unique,
    dataAdm datetime not null,
    dataDem datetime,    
    cargo varchar(45) not null, 
    email varchar(45) unique    
);
desc mecanico;
/*4*/
create table endereco(
	idEndereco int primary key not null auto_increment,
    uf varchar(2) not null,
    cidade varchar(45) not null,
    bairro varchar(45) not null,
    logadouro varchar(60) not null,
    numero int,
    cep varchar(9) not null,
    complemento varchar(45),
    cliente_cpf varchar(14) ,
    mecanico_cpf varchar(14),
    foreign key(cliente_cpf) references cliente(cpf) on update cascade on delete cascade,
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade on delete cascade    	
);
desc endereco;
/*5*/
create table telefone(
	idTelefone int primary key not null auto_increment,
    numeroTelefone varchar(11),
    cliente_cpf varchar(14),
    mecanico_cpf varchar(14),
    foreign key(cliente_cpf) references cliente(cpf) on update cascade on delete cascade,
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade on delete cascade
);
desc telefone;
/*6*/
create table servico(
	idServico int primary key not null auto_increment,
    tipo char(1) not null,
    valor decimal(6,2) not null,
    descricao varchar(80),
    nomeServico varchar(45) not null
);
/*7*/
create table tipoPeca(
	idtipoPeca int primary key not null auto_increment,
    modelo varchar(45) not null,
	quantidade decimal(6,2) not null,
    valor decimal(6,2) not null,
    marca varchar(45) not null,
    ano year(4) not null,    
    nomePeca varchar(60) not null
);

/*8*/
create table tipoPecaServico(
	tipoPeca_idtipoPeca int not null,
    servico_idServico int not null,    
    primary key(tipoPeca_idtipoPeca, servico_idServico),
    foreign key(tipoPeca_idtipoPeca) references tipoPeca(idtipoPeca),
    foreign key(servico_idServico) references servico(idServico)
);

/*9*/
create table compraPeca(
	idcompraPeca int primary key not null auto_increment,    
    data date not null,
	valor decimal(6,2) not null, 
    cliente_cpf varchar(14) not null,
    foreign key(cliente_cpf) references cliente(cpf)
);

/*10*/
create table compraTiposPeca(
	compraPeca_idcompraPeca int not null,
    tipoPeca_idtipoPeca int not null, 
    primary key(compraPeca_idcompraPeca, tipoPeca_idtipoPeca),
    foreign key(compraPeca_idcompraPeca) references compraPeca(idcompraPeca),
    foreign key(tipoPeca_idtipoPeca) references tipoPeca(idtipoPeca)
);

/*11*/
create table ordemServico(
	idordemServico int primary key not null auto_increment,    
    dataPrevista date not null,
    dataConclusao date not null,
    valorTotal decimal(6,2) not null, 
    dataEmissao date not null,
	veiculo_idVeiculo int not null,
    cliente_cpf varchar(14) not null,
    foreign key(veiculo_idVeiculo) references veiculo(idVeiculo),
    foreign key(cliente_cpf) references cliente(cpf) 
    
);

/*12*/
create table osServico(
	ordemServico_idordemServico int not null,
    servico_idServico int not null, 
    primary key(ordemServico_idordemServico, servico_idServico),
    foreign key(ordemServico_idordemServico) references ordemServico(idordemServico),
    foreign key(servico_idServico) references servico(idServico)
);

/*13*/
create table mecanicoOS(
	quantidade decimal(6,2) not null,
	mecanico_cpf varchar(14) not null,
    ordemServico_idordemServico int not null, 
    veiculo_idVeiculo int not null,
    cliente_cpf varchar(14) not null,
    primary key(mecanico_cpf, ordemServico_idordemServico,veiculo_idVeiculo,cliente_cpf),
    foreign key(mecanico_cpf) references mecanico(cpf),
    foreign key(ordemServico_idordemServico) references ordemServico(idordemServico),
	foreign key(veiculo_idVeiculo) references servico(idServico),
	foreign key(cliente_cpf) references cliente(cpf)
);
