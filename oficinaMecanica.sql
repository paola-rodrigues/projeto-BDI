/*  Para saber as base de dados comando show databases */
show databases;
    
/*-------------------------  CRIAÇÃO DA BASE DE DADOS DA OFICINA MECÂNICA---------------------------------------------------*/
create database oficinaMecanica;

use oficinaMecanica;
/*---------------------------------------------------------------------------------------------------------------------------*/
drop database oficinaMecanica;

/*-------------------------------------------------  DDL --------------------------------------------------------------------*/
/*1*/
create table cliente(
	idCliente int primary key not null auto_increment,  
    tipo varchar(45) not null
);
/*2*/
create table cliente_pessoa_fisica(
	cpf varchar(14) primary key not null,
    nome varchar(25) not null,
    genero char(1) not null,
    email varchar(45) unique,   
    cliente_idCliente int not null,
    foreign key(cliente_idCliente) references cliente(idCliente) on update cascade on delete cascade
);
desc cliente_pessoa_fisica;
/*3*/
create table cliente_pessoa_juridica(
	cnpj varchar(18) primary key not null,
    razaoSocial varchar(25) not null,
	cliente_idCliente int not null,
    foreign key(cliente_idCliente) references cliente(idCliente) on update cascade on delete cascade
);
/*drop table cliente_pessoa_juridica;*/
desc cliente_pessoa_juridica;

/*4*/
create table veiculo(
	idVeiculo int primary key not null auto_increment,    
    placa varchar(8) not null,
    modelo varchar(30) not null,
    ano year(4) not null,
    marca varchar(25) not null,
    descricao varchar(45),    
    cliente_idCliente int not null,
    foreign key(cliente_idCliente) references cliente(idCliente) on update cascade on delete cascade
);

/*5*/
create table mecanico(
	cpf varchar(14) primary key not null,
    nome varchar(60) not null,
    salario decimal(6,2) not null,
    sexo char(1) not null,
    especialidade varchar(45) not null,
    cargo varchar(45) not null,
    email varchar(45) unique,  
    dataNasc date not null,    
    dataAdm datetime not null,
    dataDem datetime   
);

/*6*/
create table endereco(
	idEndereco int primary key not null auto_increment,
    logadouro varchar(60) not null,
    numero int,
    uf varchar(2) not null,
    bairro varchar(45) not null,
    cidade varchar(45) not null,   
    cep varchar(9) not null,
    complemento varchar(45),
    cliente_idCliente int not null,
    mecanico_cpf varchar(14),
    foreign key(cliente_idCliente) references cliente(idCliente) on update cascade on delete cascade,
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade on delete cascade    	
);
/*7*/
create table telefone(
	idTelefone int primary key not null auto_increment,
    numeroTelefone varchar(11),
    cliente_idCliente int not null,
    mecanico_cpf varchar(14) not null,
    foreign key(cliente_idCliente) references cliente(idCliente) on update cascade on delete cascade,
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade on delete cascade     
);
/*8*/
create table dependente (
	cpf varchar(14) primary key not null,
    nome varchar(60) not null,
    dataNasc date not null,
    parentesco varchar(20) not null,
    mecanico_cpf varchar(14) not null,
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade on delete cascade
);
/*9*/
create table servico(
	idServico int primary key not null auto_increment,
    nomeServico varchar(45) not null,
    tipo varchar(20) not null,
    valor decimal(6,2) not null,
    descricao varchar(80)    
);
/*10*/
create table tipoPeca(
	idtipoPeca int primary key not null auto_increment,
    nomePeca varchar(60) not null,
    marca varchar(45) not null,
    modelo varchar(45) not null,
	quantidade decimal(6,2) not null,
    valor decimal(6,2) not null    
);
/*11*/
create table tipoPecaServico(
	quantidade decimal(6,2) not null,
	tipoPeca_idtipoPeca int not null,
    servico_idServico int not null,    
    primary key(tipoPeca_idtipoPeca, servico_idServico),
    foreign key(tipoPeca_idtipoPeca) references tipoPeca(idtipoPeca),
    foreign key(servico_idServico) references servico(idServico)
);
/*12*/
create table compraPeca(
	idcompraPeca int primary key not null auto_increment,    
    dataCompra date not null,
	valor decimal(6,2) not null, 
    cliente_idCliente int not null,
    foreign key(cliente_idCliente) references cliente(idCliente)
);
/*drop table compraAvPeca;*/
/*13*/
create table compraTiposPeca(
	quantidade decimal(6,2) not null,
	compraPeca_idcompraPeca int not null,
    tipoPeca_idtipoPeca int not null, 
    primary key(compraPeca_idcompraPeca, tipoPeca_idtipoPeca),
    foreign key(compraPeca_idcompraPeca) references compraPeca(idcompraPeca),
    foreign key(tipoPeca_idtipoPeca) references tipoPeca(idtipoPeca)
);
/*14*/
create table ordemServico(
	idordemServico int primary key not null auto_increment,
    dataEmissao date not null,
    dataPrevista date not null,
    statusOS varchar(45) not null,
    dataConclusao date,
    desconto decimal(6,2),
    valorTotal decimal(6,2) not null,    
	veiculo_idVeiculo int not null,
    cliente_idCliente int not null,
    foreign key(veiculo_idVeiculo) references veiculo(idVeiculo),
    foreign key(cliente_idCliente) references cliente(idCliente)     
);
/*15*/
create table osServico(
	quantidade decimal(6,2) not null,
	ordemServico_idordemServico int not null,
    servico_idServico int not null, 
    primary key(ordemServico_idordemServico, servico_idServico),
    foreign key(ordemServico_idordemServico) references ordemServico(idordemServico),
    foreign key(servico_idServico) references servico(idServico)
);
/*16*/
create table mecanicoOS(
	mecanico_cpf varchar(14) not null,
    ordemServico_idordemServico int not null, 
    primary key(mecanico_cpf, ordemServico_idordemServico),
    foreign key(mecanico_cpf) references mecanico(cpf) on update cascade, 
    foreign key(ordemServico_idordemServico) references ordemServico(idordemServico)
);

create table formPag(
	idFormPag int primary key not null auto_increment,
    tipoPag varchar(25) not null,
    valor decimal(6,2) not null,
    ordemServico_idordemServico int not null,
    foreign key(ordemServico_idordemServico) references ordemServico(idordemServico) on delete cascade
);

/*------------------------------------------ ALTERAR (DDL)------------------------------------------------------------------*/

alter table dependente add sexo char(1) not null after nome;
alter table dependente add emailDependente varchar(45) unique after dataNasc;
alter table cliente_pessoa_fisica add dataNasc date not null after nome;
alter table cliente_pessoa_juridica add email varchar(45) unique after razaoSocial;
alter table veiculo drop column descricao;
alter table cliente_pessoa_fisica drop column genero;
alter table telefone change column cliente_idCliente cliente_idCliente int;
alter table telefone change column mecanico_cpf mecanico_cpf varchar(14);
alter table endereco change column cliente_idCliente cliente_idCliente int;
alter table servico drop column tipo;
alter table servico drop column descricao;

desc dependente;
desc cliente_pessoa_fisica;
desc cliente_pessoa_juridica;
desc veiculo;
desc telefone;

/*--------------------------DESTRUIR (DDL) todas as tabelas com DROP DATABASE oficinaMecanica ------------------------------*/
/*drop database oficinaMecanica;*/

/* ------------------------------------------------DML------------------------------------------------------------------- */
/*1*/
insert into cliente (tipo)
	values ("Pessoa Física"),
			("Pessoa Jurídica"),
            ("Pessoa Física"),
            ("Pessoa Física"),
            ("Pessoa Física"),
            ("Pessoa Jurídica"),
            ("Pessoa Jurídica"),
            ("Pessoa Jurídica"),
            ("Pessoa Jurídica"),
            ("Pessoa Jurídica"),
			("Pessoa Física"),
			("Pessoa Física"),
			("Pessoa Física"),
			("Pessoa Física"),
			("Pessoa Física"),
			("Pessoa Física"),
            ("Pessoa Física"),
            ("Pessoa Física"),
            ("Pessoa Jurídica"),
            ("Pessoa Jurídica");
            
insert into cliente (tipo) 
	values ("Pessoa Física"),
		   ("Pessoa Física");           

/*2*/
insert into cliente_pessoa_fisica (cpf, nome, dataNasc, email, cliente_idCliente)
	values ("065.254.874-65", "Adelson Silva", '1993-12-20', "adelson_silva@gmail.com", 1),
		("765.387.876-34", "Arthur Brito", '1992-06-18', "arthur1992@gmail.com", 3),
        ("077.188.387-02", "Camila Lins", '2004-01-19', "camila.lins@gmail.com", 4),
        ("098.765.432-11", "Clecio Oliveira", '1993-11-25', "clecio1993@gmail.com", 5),
		("111.333.698-10", "Danubia Cabral", '2003-02-02', "danibia_10@gmail.com", 11),
        ("152.145.878-15", "Debora Sabino", '1998-05-28', "debora.sabino@gmail.com", 12),
        ("514.645.668-19", "Douglas Ramos", '1993-09-07', "douglas_20@gmail.com", 13),
        ("613.135.348-30", "Ednilson Calixto", '2000-07-30', "ednilson.calixto@gmail.com", 14),
        ("002.648.264-45", "Eduardo Veiga", '1997-04-24', "eduardo.veiga@gmail.com", 15),
        ("914.988.175-70", "Ewerton Pedrosa", '1980-08-01', "ewerton_pedrosa@gmail.com", 16),
        ("812.775.178-90", "Kátia da Silva", '1999-02-15', "katia.silva@gmail.com", 17),
        ("014.128.358-00", "Jonas Felix", '2004-12-02', "jonas.felix@gmail.com", 18), 
        ("010.253.175-09", "Adelson Nogueira", '1993-12-20', "adelson_nogueira_@gmail.com", 1);

insert into cliente_pessoa_fisica
	value  ("019.413.871-18", "Miguel Silva", '1994-05-20', "miguel.silva_@gmail.com", 21); 

/*3*/
insert into cliente_pessoa_juridica(cnpj, razaoSocial, email, cliente_idCliente)
	values ("41.105.353/0001-11", "Monteiro Maia Ltda", "monteiro.maia@monteiro.com.br", 2),
		("13.552.800/0001-14", "Vinibeck e serviços ME", "vinibeck.servicos@vinibeck.com.br", 6),
        ("11.268.845/0001-89", "Bessa veiculos Ltda", "bessa.veiculos@gmail.com", 7),
        ("03.719.672/0001-40", "Rita Cassio ME",  "rita.cassio3@gmail.com", 8),
		("40.493.561/0001-94", "Multi Ltda",  "multi@gmail.com", 9),
        ("74.094.830/0001-61", "JJS Construção Ltda", "jjs.construcao@gmail.com", 10),
        ("14.114.297/0001-20", "Norte Sul Ltda",  "norte.sul@gmail.com", 19),
        ("07.568.540/0001-15", "EJS Construções Ltda", "ejs.construcoes@gmail.com", 20);    

/*4*/
insert into veiculo(placa, modelo, ano, marca, cliente_idCliente)
	values ("BEE-4R22", "Siena", "2010", "Fiat", 1),
		   ("KFD-0155", "Brava", "2011", "Fiat", 2),
           ("LVE-6789", "Palio", "2009", "Fiat", 3),
           ("KMF-4R22", "Strada", "2020", "Fiat", 4),           
           ("MNN-4R22", "Panaroma", "2015", "Fiat", 5),           
           ("MOX-4R22", "Fit", "2009", "Honda", 6),
           ("MUA-4R22", "City", "2013", "Honda", 7),
           ("MXH-4R22", "New Fit", "2008", "Honda", 8),           
           ("NEI-4R22", "Hoggar", "2007", "Peugeot", 9),
           ("NLV-4R22", "Peugeot", "2010", "Peugeot", 10),           
           ("NMP-4R22", "Peugeot", "2019", "Peugeot", 11),           
           ("NIP-4R22", "Ranger", "2011", "Ford", 12),
           ("NHU-4R22", "Fiesta", "2020", "Ford", 13),
           ("NBB-4R22", "Focus", "2005", "Ford", 14),
           ("NAG-4R22", "Ka", "2000", "Ford", 15),           
           ("NEF-4R22", "Fusion", "2020", "Ford", 16),           
           ("KME-4R22", "Renegade", "2010", "Jeep", 17),
           ("KFC-4R22", "Commander", "2015", "Jeep", 18),
           ("JXC-4R22", "Compass", "2008", "Jeep", 19),
           ("JWE-4R22", "Renegade", "2006", "Jeep", 20);

/*5*/
insert into mecanico(cpf, nome, salario, sexo, especialidade, cargo, email, dataNasc, dataAdm, dataDem)
	values ("066.154.874-37", "Adriano Santos", 1800.00, 'F', "Ajustadora", "Mecânico", 'adriana.santos@gmail.com', '2000-06-04','2021-06-04 13:30:00', null),
    	   ("102.406.954-01", "Alines Alves", 2000.00, 'F', "Inspetor", "Técnico em Mecânica", 'aline_alves@gmail.com', '1990-08-24','2020-05-03 14:40:00', null);
 
insert into mecanico
	values ("156.160.881-41", "Eduardo Ferreira", 1500.00, 'M', "Montagem", "Montador", 'eduardo.ferreira@gmail.com', '1988-09-01','2020-07-15 13:45:00', null),
           ("300.251.117-09", "Antonio Moura", 2000.00, 'M', "Pintura", "Pintor Automotivo", 'antonio.moura_07@gmail.com', '1990-11-25','2021-06-04 11:30:00', null),
		   ("077.445.222-11", "Carlos Eduardo", 1800.00, 'F', "Lanternagem", "Lanterneiro",'carlos.eduardo10@gmail.com', '2000-02-16','2019-05-15 15:30:00', null),
           ("900.136.987-15", "Brena Correia", 2500.00, 'F', "supervisão", "Gerente", 'brena_correia@gmail.com', '2002-06-04','2021-06-25 11:20:00', null),          
          ("098.765.432-11", "Denis Ferreira", 1900.00, 'M', "Manutenção", "Técnico em Mecânica", 'denis_ferreira_800@gmail.com', '1999-07-15','2021-03-15 08:00:00', '2021-06-14 17:30:00'),
           ("166.051.174-01", "Hugo Silva", 1300.00, 'M', "Limpeza", "Auxiliar de Mecânico", 'hugo2000@gmail.com', '1988-12-28','2015-11-04 13:30:00', null),
           ("300.945.310-80", "Igor Oliveira", 1900.00, 'M', "Manutenção", "Técnico em Mecânica", 'igor.oliveira_15@gmail.com', '2016-07-26','2021-06-04 12:30:00', null),
           ("228.001.874-37", "Luiz Silva", 1800.00, 'M',"Montagem", "Montador",  'luiz.silva701@gmail.com', '2000-06-04','2017-09-14 08:30:00', null),
           ("478.710.456-01", "Marcello Gabriele", 2000.00, 'M', "Pintura", "Pintor Automotivo",'marcello2002@gmail.com', '1985-07-04','2016-06-04 09:30:00', null),
           ("547.171.991-65", "Paulo Cesar", 1800.00, 'M',  "Lanternagem", "Lanterneiro", 'paulo..cesar@gmail.com', '2001-10-04','2018-06-04 10:30:00', null),
           ("291.412.007-14", "Sergio Lopes", 1800.00, 'M', "Ajustador", "Mecânico", 'sergio.lopes_10@gmail.com', '2003-06-14','2019-06-04 11:30:00', null),
           ("710.710.819-13", "Karoline Juliana", 1500.00, 'F', "Montagem", "Montador",  'karolina.s.j20@gmail.com', '1999-01-28','2019-06-04 13:30:00', null),
           ("800.391.734-05", "Eduarda Santana", 1300.00, 'F', "Limpeza", "Auxiliar de Mecânico", 'eduarda_santana22@gmail.com', '1987-04-02','2015-06-04 15:30:00', null),
           ("016.366.256-09", "Cleyton Silva", 1800.00, 'M', "Lanternagem", "Lanterneiro", 'cleyton.silva77@gmail.com', '2000-06-30','2020-06-04 08:00:00', null),
           ("410.501.123-17", "Felipe Pereira", 1300.00, 'M', "Limpeza", "Auxiliar de Mecânico", 'felipe_pereira_@gmail.com', '2000-10-20','2021-06-04 13:30:00', null),
           ("448.111.345-09", "Jessica Nascimento", 1900.00, 'F', "Manutenção", "Técnico em Mecânica", 'jessica.nascimento_1@gmail.com', '1989-09-19','2017-06-04 13:30:00', null),
           ("789.151.001-65", "Juliana Nogueira", 1800.00, 'F', "Instalação", "Mecânico", 'juliana.nogueira.adm@gmail.com', '2002-03-15','2020-06-04 14:00:00', null),
    	   ("011.056.914-31", "David Rodrigues", 2000.00, 'M', "Inspetor", "Técnico em Mecânica", 'david.ads_@gmail.com', '1990-04-24','2018-05-03 14:40:00', null);
   
/*6*/
insert into endereco(logadouro, numero, uf, bairro, cidade, cep, complemento, cliente_idCliente, mecanico_cpf)
	values ("Rua Nordestina", null, "PE", "Areias", "Recife", "50771-000", null, 1, null),
		   ("Rua Santa Rita", 2130,"PE", "Aflitos", "Recife","50810-480", "sala 357", 2, null),
           ("Rua Vinte e Um de Abril", 011, "PE","San Martin", "Recife", "50761-350", "Casa A", 3, null),
           ("Rua Formosa", 2130, "PE", "Aflitos","Recife", "50630-300", "Ap 1803", 4, null),
           ("Rua Nova Era", 111, "PE", "Aflitos", "Recife", "50940-660", "Ap 175", 5, null),           
           ("Rua Jean Emile Favre", 19, "PE", "Imbiribeira", "Recife", "51200-060", "sala 101", 6, null),
           ("Rua Dr. Manoel de Barros Lima", 2130, "PE", "Bairro Novo", "OLinda","55303-245", "sala 501", 7, null),           
           ("Rua Guiné", 11, "PE", "Pau Amarelo", "Paulista", "50761-350", null, 8, null),
           ("Rua Saire", 52, "PE", "Nossa Senhora do Ó", "Paulista", "50761-350", "sala 200", 9, null),
           ("Av. Costa Azul", 135, "PE", "Maria Farinha,", "Paulista", "50761-350", "sala 75", 10, null),           
           ("Rua São Mateus", 401, "PE", "Iputinga", "Recife","54753-600", null, 11, null),
           ("Rua Capitão Aureliano", 781, "PE", "Engenho do Meio", "Recife", "50730-150", null, 12, null),           
           ("Rua Gomes Taborda", 506, "PE", "Torrões", "Recife", "50761-350", "Casa B", 13, null),           
           ("Rua Ribeiro de Brito", 530, "PE", "Boa Viagem", "Recife", "51021-310", null, 14, null),
           ("Rua padre carapuceiro", 119, "PE", "Boa Viagem", "Recife","51020-000", null, 15, null),
           ("Rua Faustino Porto", 3000, "PE", "Boa Viagem", "Recife","51020-000", null, 16, null),
           ("Rua Mamanguape", 006, "PE", "Boa Viagem", "Recife","51020-000", "Casa C", 17, null),
           ("Rua Carlos Pereira Falcão", 1135, "PE", "Boa Viagem", "Recife","51021-350", "Ap 10", 18, null),
           ("Av Visc de jequitinhonha", 1145, "PE", "Boa Viagem", "Recife", "51030-021", "sala 751", 19, null),
           ("Rua João Teixeira", 65, "PE", "Estância", "Recife", "50771-450", "sala 801", 20, null);   

insert into endereco(logadouro, numero, uf, bairro, cidade, cep, complemento, cliente_idCliente, mecanico_cpf)
	values ("Rua Tupy", 11, "PE", "Areias", "Recife","50771-500", null, null, "066.154.874-37"),
           ("Rua do Rio", 105, "PE", "Estância", "Recife", "50771-695", "Casa B", null,  "102.406.954-01"),
	       ("Av Tapajós", 899, "PE", "Areias", "Recife","50860-010", "Casa A", null,  "156.160.881-41"),
	       ("Rua Luíz Mendonça", 101, "PE", "Areias", "Recife","50860-200", "Ap 711", null, "300.251.117-09"),       
	       ("Rua Eraldo de Barros", 65, "PE", "Areias", "Recife", "50860-020", null, null, "077.445.222-11"),
	       ("Rua Aurora", 50, "PE", "Caçote", "Recife","50870490", null, null,  "900.136.987-15"),          
           ("Rua Etapas", 35, "PE", "Caçote", "Recife", "50875-040", "Ap 115", null, "098.765.432-11"),
           ("Rua Bento Teixeira", 10, "PE", "Areias", "Recife","50870-800", null, null,"166.051.174-01"),
           ("Rua Aracaju", 78, "PE", "Tejipio", "Recife","50920-490", null, null, "300.945.310-80"),
           ("Rua Guanabara", 509, "PE", "Coqueiral", "Recife","5079-100", null, null, "228.001.874-37"),
           ("Rua Jacunda", 14, "PE", "Ipsep", "Recife","51350-080", null, null, "478.710.456-01"),
           ("Rua Irapuã", 71, "PE", "Ipsep", "Recife","51350-630", null, null, "547.171.991-65"),
           ("Rua Rio Ipojuca", 451, "PE", "Ipsep", "Recife","51190-440", null, null, "291.412.007-14"),
           ("Rua Rio Maranhão", 800, "PE", "Ipsep", "Recife","51190-430", null, null, "710.710.819-13"),
           ("Rua rio xingu", 630, "PE", "Ibura", "Recife","51240-040", null, null, "800.391.734-05"),
           ("Rua Dois", 778, "PE", "Cajueiro Seco", "Jaboatão dos Guararapes","54330-435", "Casa A", null, "016.366.256-09"),
           ("Rua três", 321, "PE", "Cajueiro Seco", "Jaboatão dos Guararapes","54330-240", null, null,"410.501.123-17"),
           ("Rua Cinco", 313, "PE", "Cajueiro Seco", "Jaboatão dos Guararapes","54330-060", "Ap 02", null, "448.111.345-09"),
           ("Rua Recife", 798, "PE", "Cajueiro Seco", "Jaboatão dos Guararapes","54330-250", "Ap 11", null, "789.151.001-65"),
           ("Rua Emiliano Ribeiro", 100, "PE", "Cajueiro Seco", "Jaboatão dos Guararapes","54310-250", "Casa C", null, "011.056.914-31");

/*7*/
insert into telefone(numeroTelefone, cliente_idCliente, mecanico_cpf)
	values ("8199985671", null, "066.154.874-37"),
           ("8198955662", null,  "102.406.954-01"),
	       ("81985773045", null,  "156.160.881-41"),
	       ("81996951000", null, "300.251.117-09"),       
	       ("81999747414", null,"077.445.222-11"),
	       ("8198736304", null,  "900.136.987-15"),          
           ("81992751696", null,"098.765.432-11"),
           ("81984169671", null,"166.051.174-01"),
           ("81995174868", null,"300.945.310-80"),
           ("81996162786", null, "228.001.874-37"),
           ("81997478810", null, "478.710.456-01"),
           ("81988924146", null, "547.171.991-65"),
           ("81987417377", null, "291.412.007-14"),
           ("81971128581", null,"710.710.819-13"),
           ("81979082688", null, "800.391.734-05"),
           ("81979082688", null, "016.366.256-09"),
           ("81984837153", null,"410.501.123-17"),
           ("81998893927", null,"448.111.345-09"),
           ("81998474347", null, "789.151.001-65"),
           ("81996210440", null, "011.056.914-31"),
           ("8199412245", 1, null),
           ("81992133322", 2, null),
           ("81992260607", 3, null),
           ("81999208883", 4, null),
           ("81981227433", 5, null),
           ("81999167161", 6, null),
           ("81982310977", 7, null),
           ("81984051535", 8, null),
           ("81984270152", 9, null),
           ("81985371489", 10, null),
           ("81986421702", 11, null),
           ("81986662833", 12, null),
           ("81986957445", 13, null),
           ("81987674746", 14, null),
           ("81987844343", 15, null),
           ("81988104600", 16, null),
           ("81988331650", 17, null),
           ("81988483072", 18, null),
           ("81991317176", 19, null),
           ("81920004324", 20, null);

/*8*/
insert into dependente(cpf, nome, sexo, dataNasc, emailDependente, parentesco, mecanico_cpf)
	values ("133.001.700-09", "Allan Arruda", "M", '2021-05-03', null, "Filho", "066.154.874-37"),
           ("061.352.211-10", "Filipe Costa", 'M' , '2016-01-15', "filipe.costa_2021@gmail.com", "Filho", "102.406.954-01"),
           ("269.486.143-25", "Angelica Casagrande", "F", '2018-05-21', "angelica..casagrande10@gmail.com", "Filha", "102.406.954-01"),           
	       ("367.151.061-02", "Carlos Henrique", "M", '2013-11-09', null, "Filho", "156.160.881-41"),
           ("910.055.981-22", "Gustavo Albuquerque", "M", '2010-08-11', null, "Filho", "156.160.881-41"),           
	       ("900.109.079-20", "Gustavo Banhos", "M", '2021-02-12', null, "Filho", "300.251.117-09"),       
	       ("007.264.449-61", "Isaac Maia", "M", '2022-04-24', null,"Filho", "077.445.222-11"),
	       ("099.210.250-06", "José Neto", "M", '2021-06-30', null, "Filho", "900.136.987-15"),          
           ("066.626.252-51", "Jose Augusto", "M", '2022-01-15', null, "Filho", "098.765.432-11"),           
           ("044.642.601-36", "Lidenberg Rodrigues", "M", '2012-12-25', "lidenberg.rodrigues_25@gmail.com", "Filho", "166.051.174-01"),
           ("014.456.724-77", "Bruna Bezerra", "F", '2009-10-22', "bruna.bezerra_22@gmail.com", "Filha", "166.051.174-01"),
           ("140.300.980-39", "Mara Oliveira", "F", '2010-03-15', "mara.oliveira_15@gmail.com", "Filha", "166.051.174-01"),           
           ("329.456.456-40", "Mateus Bandeira", "M", "1997-01-01", "mateus.bandeira_01@gmail.com", "Filho", "478.710.456-01"),
           ("507.601.381-09", "Marleton Bandeira", "M", "1998-05-03", "marleton.bandeira_03@gmail.com", "Filho", "478.710.456-01"),
           ("271.051.779-16", "Mariana Bandeira", "F", "1999-07-14", "mariana.bandeira_14@gmail.com", "Filha", "478.710.456-01"),           
           ("801.845.907-21", "Maria Bandeira", "F", "2000-09-21", "maria.bandeira_21@gmail.com", "Filha", "478.710.456-01"),            
           ("709.011.654-14", "Natália Aguiar", "F", "2020-10-04", null, "Filha", "016.366.256-09"),           
           ("067.051.147-61", "Raiane Silva", "F", "2019-05-11", null,"Filha", "410.501.123-17"),
           ("091.656.159-55", "Raquel Silva", "F", "2021-09-18", null, "Filha", "410.501.123-17"),           
           ("723.456.951-07", "Tales Carvalho", "M", "2012-05-11", "tales_carvalho_11@gmail.com", "Filho", "011.056.914-31"),           
           ("510.456.258-56", "Thiago Carvalho", "M", "2007-04-21", "thiago_carvalho_21@gmail.com", "Filho", "011.056.914-31"),
           ("451.456.963-71", "Valeria Carvalho", "F", "2009-03-02", "valeria_carvalho_02@gmail.com", "Filha", "011.056.914-31");

/*9*/
insert into servico(nomeServico, valor)
	values ("Alternador", 80.0),
           ("Manutenção de embreagem", 150.0),
           ("Manutenção arrefecimento", 140.0),
           ("Balanceamento", 95.0),
           ("Alinhamento", 110.0),
           ("Conserto de furo de pneu", 50.0),
           ("Regulagem Farol Dianteiro", 70.0),
           ("Limpeza de bicos", 100.0),
           ("Troca de filtros", 80.0),
           ("Troca de lâmpadas", 30.0),
           ("Trocar de mangueira", 45.0),
           ("Troca de discos", 55.0),
           ("Troca de pastilhas", 60.0),
           ("Trocar tambor", 55.0),
           ("Troca sapatas", 75.0),
           ("Troca de filtros", 70.0),
           ("Troca de óleo", 50.0),
           ("Troca de bateria", 60.0),
           ("Martelinho de ouro", 200.0),
           ("Substituição para-brisas", 130.0),
           ("Instação de película", 60.0);

/*10*/
insert into tipoPeca(nomePeca, marca, modelo, quantidade, valor)
	values ("Anel de pistão", "Mahle", "AKX-3536", 100.0, 65.0),
           ("Anel de pistão", "Cofap", "AKX-35722", 50.0, 66.0),
           ("Buzina", "Bosch", "DNI-0134", 30.0, 50.0),
           ("Buzina", "Fiamm", "GAN-1394", 30.0, 55.0),
           ("Bomba de combustível", "Bosch", "TKZ-4156", 15.0, 100.0),
           ("Bomba de combustível", "Brosol", "NKB-0725", 20.0, 130.0),
           ("Bomba de combustível", "Nakata", "TKZ-4159", 15.0, 110.0),
           ("Bomba de combustível", "Schadek", "TTZ-4255", 16.0, 105.0),
           ("Farol", "Ford", "TKZ-1821", 10.0, 145.0),
           ("Farol", "Fiat", "EFL-0925", 10.0, 130.0),
           ("Farol", "Jeep", "PSL-0156", 10.0, 105.0),
           ("Farol", "Peugeot", "PSL-0419", 11.0, 100.0),
           ("Sensor de temperatura", "Bosch", "TKZ-4156", 15.0, 100.0),
           ("Sensor de temperatura", "Mte", "NKB-0725", 20.0, 130.0),
           ("Sensor de temperatura", "Vdo", "TKZ-4159", 15.0, 110.0),
           ("Sensor de temperatura", "Magneti", "TTZ-4255", 16.0, 105.0), 
           ("Pistão", "Bosch", "TKZ-0920", 25.0, 100.0),
           ("Pistão", "Mte", "NKB-0941", 6.0, 130.0),
           ("Pistão", "Vdo", "TKZ-1331", 8.0, 110.0),
           ("Pistão", "Magneti", "TTZ-4411", 10.0, 120.0),
           ("Pistão", "ford", "TTZ-7642", 11.0, 130.0),        
           ("Regulador De Tensão", "Ford", "PSL-0568", 14.0, 90.0),
           ("Regulador De Tensão", "Fiat", "PSL-0281", 11.0, 95.0),
           ("Regulador De Tensão", "Jeep", "PSC-4960", 10.0, 93.0),
           ("Regulador De Tensão", "Peugeot", "PSL-9090", 13.0, 96.0),
           ("Regulador De Tensão", "Honda", "GAL-0803", 12.0, 89.0),			
           ("Retificador", "Ford", "TKK-0151", 11.0, 110.0),
           ("Retificador", "Fiat", "NKB-1734", 20.0, 130.0),
           ("Retificador", "Jeep", "TKZ-3229", 15.0, 120.0),
           ("Retificador", "Peugeot", "TTZ-1000", 16.0, 110.0),
           ("Retificador", "Honda", "TTZ-2090", 16.0, 105.0),
           ("Válvula", "Ford", "TAZ-1156", 11.0, 50.0),
           ("Válvula", "Fiat", "NAB-0515", 10.0, 60.0),
           ("Válvula", "Jeep", "TKZ-4250", 15.0, 65.0),
           ("Válvula", "Peugeot", "TTZ-0602", 16.0, 85.0),
           ("Válvula", "Honda", "TTZ-0959", 16.0, 70.0),         
           ("Pastilha De Freio", "Ford", "TAZ-0958", 15.0, 65.0),
           ("Pastilha De Freio", "Fiat", "NKB-0225", 20.0, 75.0),
           ("Pastilha De Freio", "Jeep", "TKA-4237", 15.0, 90.0),
           ("Pastilha De Freio", "Peugeot", "TAZ-8755", 10.0, 85.0),
           ("Pastilha De Freio", "Honda", "TTZ-6196", 12.0, 95.0),           
           ("Filtro De Ar", "Nox", "PSL-9580", 5.0, 85.0),
           ("Filtro De Ar", "Wix", "SBA-0444", 20.0, 75.0),
           ("Filtro De Ar", "Race", "TCA-1530", 15.0, 80.0),
           ("Filtro De Ar", "Aem", "TTH-1271", 16.0, 90.0),
           ("Filtro De Ar", "Inflow", "TTH-1555", 16.0, 95.0),           
		   ("Bateria", "Moura", "TKZ-4156", 15.0, 150.0),
           ("Bateria", "Bosh", "NKB-0725", 20.0, 130.0),
           ("Bateria", "Heliar", "TKZ-4159", 15.0, 120.0),
           ("Bateria", "Cral", "TTZ-4255", 16.0, 150.0),
           ("Bateria", "ACDelco", "TTZ-4255", 16.0, 130.0),         
	       ("Filtro De Combustível", "Bosh", "TKZ-4156", 10.0, 110.0),
           ("Filtro De Combustível", "Fram", "NKB-0725", 10.0, 135.0),
           ("Filtro De Combustível", "Mann", "TKZ-4159", 9.0, 110.0),
           ("Filtro De Combustível", "Kia&cia", "TTZ-4255", 8.0, 109.0),
           ("Filtro De Combustível", "Tecfil", "TTZ-4255", 9.0, 115.0),           
           ("Filtro De Óleo", "Bosh", "TKZ-4156", 20.0, 100.0),
           ("Filtro De Óleo", "Fram", "NKB-0725", 25.0, 130.0),
           ("Filtro De Óleo", "Mann", "TKZ-4159", 10.0, 110.0),
           ("Filtro De Óleo", "Kia&cia", "TTZ-4255", 16.0, 105.0),
           ("Filtro De Óleo", "Tecfil", "TTZ-4255", 18.0, 105.0);

/*11*/
insert into tipoPecaServico(quantidade, tipoPeca_idtipoPeca, servico_idServico)
	values (1, 1, 1),
           (2, 3, 1),
           (3, 5, 2),
           (2, 4, 3),
           (5, 6, 3),
           (2, 7, 3),
           (1, 8, 20),
           (2, 9, 19),
           (4, 10, 13),
           (4, 11, 4),
           (1, 12, 5),
           (1, 13, 1),
           (2, 14, 1),
           (1, 15, 1),
           (2, 16, 1),
           (2, 17, 1),
           (3, 19, 1),
           (1, 22, 1),
           (1, 28, 19),
           (2, 29, 13);          

/*12*/
insert into compraPeca(dataCompra, valor, cliente_idCliente)
	values ("2021-03-02", 100.0, 1),
           ("2021-11-15", 250.0, 1),           
           ("2021-06-10", 300.0, 2),
           ("2020-05-24", 150.0, 2),
           ("2019-11-06", 160.0, 2),           
           ("2021-04-11", 250.0, 3),
           ("2020-01-22", 170.0, 3),
           ("2019-03-01", 100.0, 3),           
           ("2022-10-16", 160.0, 4),
           ("2021-08-30", 140.0, 4),
           ("2020-07-05", 120.0, 4),           
           ("2022-04-12", 450.0, 5),
		   ("2021-06-19", 500.0, 5),	   
           ("2019-08-05", 600.0, 5),           
           ("2022-01-15", 120.0, 6),
           ("2021-03-21", 150.0, 6),
           ("2020-07-28", 130.0, 6),           
           ("2022-04-18", 110.0, 7),
           ("2021-03-26", 110.0, 7),
           ("2021-11-06", 140.0, 8),
           ("2019-09-07", 90.0, 9),           
           ("2022-04-09", 200.0, 10),
           ("2021-01-20", 350.0, 10),
           ("2019-05-30", 150.0, 10),           
           ("2022-01-04", 160.0, 11),
		   ("2019-10-11", 135.0, 11),
           ("2022-08-14", 260.0, 12),           
           ("2020-04-18", 150.0, 13),
           ("2022-07-26", 130.0, 13),           
           ("2022-11-16", 100.0, 14),
           ("2022-08-20", 230.0, 15),
           ("2021-12-27", 105.0, 15),           
           ("2020-07-26", 215.0, 16),
           ("2022-05-14", 65.0, 16),
           ("2022-03-09", 62.0, 17),           
           ("2022-01-26", 110.0, 18),
           ("2021-04-04", 180.0, 18),           
           ("2022-01-11", 115.0, 19),
           ("2021-05-07", 130.0, 19),
           ("2022-03-22", 160.0, 20);  

/*13*/
insert into compraTiposPeca(quantidade, compraPeca_idcompraPeca, tipoPeca_idtipoPeca)
	values (1, 1, 5), 
           (1, 2, 5), 
           (1, 2, 57),
           (1, 2, 3),
           (2, 3, 50), 
           (1, 4, 35),
           (1, 4, 1),
           (1, 5, 23),
           (1, 5, 34),
           (1, 6, 58),
           (1, 6, 29),           
           (1, 7, 44),
           (1, 7, 22),
           (1, 8, 5), 
           (1, 9, 36),
           (1, 9, 45),
           (1, 10, 1),
           (1, 10, 38), 
           (1, 11, 36),
           (1, 11, 3), 
           (1, 12, 6),           
           (1, 12, 20),
           (2, 12, 57),           
           (5, 13, 57), 
           (8, 14, 32),
           (1, 14, 12),
           (1, 14, 13),           
		   (1, 15, 20), 
		   (1, 16, 47), 
           (1, 17, 48), 
           (1, 18, 54),
           (1, 19, 52), 
           (2, 20, 36),            
           (1, 21, 22), 
           (2, 22, 57), 
           (4, 23, 32), 
           (1, 23, 13),
           (1, 23, 3),
           (1, 24, 47), 
           (1, 25, 23), 
           (1, 25, 1),           
           (1, 26, 36),
           (1, 26, 37),
           (1, 27, 35), 
           (1, 27, 38),
           (1, 27, 57),           
           (1, 28, 47), 
           (1, 29, 58), 
           (1, 30, 57),
           (1, 31, 5),
		   (1, 31, 6), 
		   (1, 32, 16),  
		   (1, 33, 13), 
           (1, 34, 1), 
           (1, 35, 2), 
           (1, 36, 27), 
           (1, 37, 10), 
           (1, 37, 3),
           (1, 38, 34), 
		   (1, 38, 32),
           (1, 39, 48),
           (1, 39, 18), 
           (2, 40, 17), 
           (1, 40, 33),
           (1, 40, 13);         

/*14*/
insert into ordemServico(dataEmissao, dataPrevista, statusOS, dataConclusao, desconto, valorTotal, veiculo_idVeiculo, cliente_idCliente)
	values ("2020-03-22", "2020-04-22", "Finalizada", "2020-04-20", null, 550.0, 1, 1),
           ("2020-01-20", "2020-02-19", "Cancelada", null, null, 800.0, 2, 2),
           ("2020-05-15", "2020-06-19", "Finalizada", "2020-06-19", null, 650.0, 3, 3),
           ("2020-02-06", "2020-03-08", "Finalizada", "2020-03-10", null, 850.0, 6, 6),
	       ("2020-04-12", "2020-05-12", "Finalizada", "2020-05-19", null, 450.0, 7, 7),
           ("2020-06-01", "2020-06-28", "Cancelada", null, null, 650.0, 8, 8),
           ("2020-09-12", "2020-09-30", "Finalizada", "2020-09-30", null, 300.0, 9, 9),
           ("2020-01-09", "2020-01-29", "Finalizada", "2020-01-29", null, 350.0, 10, 10),
		   ("2020-08-18", "2020-06-18", "Finalizada", "2020-06-20", null, 680.0, 11, 11),
           ("2020-06-20", "2020-07-19", "Finalizada", "2020-07-19", null, 200.0, 12, 12),
           ("2020-05-21", "2020-06-16", "Cancelada", null,  null, 750.0, 13, 13),
           ("2020-04-25", "2020-05-20", "Finalizada", "2020-05-19", null, 780.0, 14, 14),
           ("2020-02-15", "2020-03-09", "Finalizada", "2020-03-07", null, 950.0, 15, 15),
           ("2020-01-08", "2020-01-30", "Cancelada", null, null, 580.0, 18, 18),
           ("2020-09-20", "2020-10-19", "Finalizada", "2020-10-15", null, 980.0, 19, 19),  
           ("2021-01-22", "2021-02-19", "Finalizada", "2021-02-18", null, 600.0, 1, 1),
           ("2021-01-08", "2021-01-28", "Finalizada", "2021-01-27", null, 650.0, 2, 2),
           ("2021-01-12", "2021-01-22", "Finalizada", "2021-01-20", null, 350.0, 2, 2),
		   ("2021-02-05", "2021-02-15", "Finalizada", "2021-02-15", null, 500.0, 3, 3),           
		   ("2021-03-01", "2021-03-19", "Finalizada", "2021-03-18", null, 780.0, 3, 3),
           ("2021-03-23", "2021-03-19", "Finalizada", "2021-03-19", null, 670.0, 4, 4),
           ("2021-03-04", "2021-03-20", "Finalizada", "2021-03-20", null, 480.0, 5, 5),
           ("2021-03-11", "2021-04-15", "Finalizada", "2021-04-15", null, 980.0, 6, 6),
           ("2021-03-06", "2021-03-21", "Finalizada", "2021-03-20", null, 350.0, 7, 7),           
           ("2021-03-02", "2021-04-03", "Finalizada", "2021-04-03", null, 400.0, 8, 8),
           ("2021-06-01", "2021-06-28", "Cancelada", null, null, 650.0, 8, 8),
           ("2021-03-15", "2021-04-30", "Finalizada", "2021-04-29", null, 560.0, 9, 9),           
           ("2021-04-22", "2021-05-22", "Finalizada", "2021-05-20", null, 520.0, 10, 10),
           ("2021-01-12", "2021-01-22", "Finalizada", "2021-01-20", null, 380.0, 10, 10),
           ("2021-03-22", "2021-03-30", "Finalizada", "2021-03-30", null, 400.0, 11, 11),
           ("2021-02-04", "2021-02-14", "Finalizada", "2021-02-14", null, 950.0, 12, 12),
           ("2021-02-15", "2021-02-27", "Finalizada", "2021-02-27", null, 720.0, 13, 13),           
           ("2021-05-10", "2021-05-22", "Finalizada", "2021-05-21", null, 600.0, 14, 14),
           ("2021-05-11", "2021-05-26", "Finalizada", "2021-05-26", null, 740.0, 15, 15),
           ("2021-05-13", "2021-05-28", "Finalizada", "2021-05-28", null, 500.0, 16, 16),
           ("2021-05-14", "2021-05-30", "Finalizada", "2021-05-30", null, 750.0, 17, 17),
           ("2021-02-04", "2021-02-15", "Finalizada", "2021-02-15", null, 850.0, 17, 17),           
           ("2021-06-01", "2021-06-18", "Finalizada", "2021-06-18", null, 900.0, 18, 18),
           ("2021-06-12", "2021-06-28", "Finalizada", "2021-06-28", null, 650.0, 19, 19),
           ("2021-09-13", "2021-09-24", "Finalizada", "2021-09-25", null, 750.0, 19, 19),
           ("2021-06-15", "2021-06-30", "Finalizada", "2021-06-30", null, 360.0, 20, 20),
           ("2022-01-11", "2022-01-19", "Finalizada", "2022-04-20", null, 300.0, 1, 1),
           ("2022-01-12", "2022-01-20", "Finalizada", "2022-04-20", null, 150.0, 2, 2),
		   ("2022-01-15", "2022-01-25", "Finalizada", "2022-04-20", null, 250.0, 3, 3),           
           ("2022-02-02", "2022-02-15", "Finalizada", "2022-04-20", null, 450.0,4, 4),
           ("2022-02-09", "2022-02-17", "Finalizada", "2022-04-20", null, 550.0,5, 5),
           ("2022-02-14", "2022-02-22","Cancelada", null, null, 850.0,6, 6),
           ("2022-02-21", "2022-03-04", "Cancelada", null, null, 950.0, 7, 7),           
           ("2022-03-03", "2022-03-30", "Finalizada", "2022-03-30", null, 980.0, 8, 8),
           ("2022-03-16", "2022-03-27", "Finalizada", "2022-03-27", null, 650.0, 9, 9),
           ("2022-03-18", "2022-03-28", "Finalizada", "2022-03-28", null, 720.0, 10, 10),           
           ("2022-04-05", "2022-04-20", "Finalizada", "2022-04-20", null, 150.0, 11, 11),
           ("2022-04-07", "2022-04-21", "Finalizada", "2022-04-21", null, 350.0, 12, 12),
           ("2022-04-15", "2022-04-30", "Finalizada", "2022-04-30", null, 450.0, 13, 13),           
           ("2022-05-01", "2022-05-17", "Finalizada", "2022-05-17", null, 200.0, 14, 14),
           ("2022-05-09", "2022-05-20", "Finalizada", "2022-05-20", null, 250.0, 15, 15),
           ("2022-05-19", "2022-05-30", "Finalizada", "2022-05-30", null, 850.0, 16, 16),           
           ("2022-06-02", "2022-06-19", "Finalizada", "2022-06-19", null, 620.0, 17, 17),
           ("2022-06-23", "2022-06-30", "Finalizada", "2022-06-30", null, 300.0, 18, 18),           
           ("2022-07-06", "2022-07-30", "em andamento", null, null, 750.0, 19, 19),
           ("2022-07-07", "2022-07-14", "em andamento", null, null, 200.0, 1, 1),
           ("2022-07-15", "2022-08-05", "aguardando aprovação", null, null, 950.0, 20, 20);

/*15*/
insert into osServico(quantidade, ordemServico_idordemServico, servico_idServico)
	values (4, 1, 8),
		   (4, 1, 6),           
           (3, 3, 19),
           (1, 3, 17),           
           (4, 4, 6),
           (4, 4, 8),
           (1, 4, 3),
           (1, 4, 5),           
           (1, 5, 2),
           (1, 5, 7),
		   (1, 5, 10),
           (2, 5, 8),  
           (3, 7, 12),
           (1, 7, 11),
           (1, 7, 13),
           (1, 7, 10),           
		   (1, 8, 1),
           (1, 8, 2),  
           (2, 8, 13),
		   (3, 9, 19), 
		   (1, 9, 9),     
           (1, 18, 1),
           (1, 18, 2),  
           (2, 18, 13);

 select * from  osServico; 
desc mecanicoOS; 
/*16*/
insert into mecanicoOS(mecanico_cpf, ordemServico_idordemServico)
	values ("066.154.874-37", 1),
    	   ("102.406.954-01", 1),
		   ("156.160.881-41", 3),
           ("300.251.117-09", 4),
		   ("077.445.222-11", 5),
           ("900.136.987-15", 5),          
           ("098.765.432-11", 7),
           ("166.051.174-01", 8),
           ("300.945.310-80", 9),
		   ("228.001.874-37", 10),
           ("478.710.456-01", 12),
           ("547.171.991-65", 13),
           ("291.412.007-14", 15),
           ("710.710.819-13", 16),
           ("800.391.734-05", 17),
           ("016.366.256-09", 18),
           ("410.501.123-17", 19),
           ("448.111.345-09", 20),
           ("789.151.001-65", 21),
    	   ("011.056.914-31", 22),           
		   ("066.154.874-37", 23),
    	   ("102.406.954-01", 24),
		   ("156.160.881-41", 25),
           ("300.251.117-09", 25),
		   ("077.445.222-11", 27),
           ("900.136.987-15", 28),          
           ("098.765.432-11", 29),
           ("166.051.174-01", 30),
           ("300.945.310-80", 31),
		   ("228.001.874-37", 32),
           ("478.710.456-01", 33),
           ("547.171.991-65", 34),
           ("291.412.007-14", 35),
           ("710.710.819-13", 36),
           ("800.391.734-05", 37),
           ("016.366.256-09", 38),
           ("410.501.123-17", 39),
           ("448.111.345-09", 40),
           ("789.151.001-65", 41),
    	   ("011.056.914-31", 42),           
		   ("066.154.874-37", 43),
    	   ("102.406.954-01", 44),
		   ("156.160.881-41", 45),
           ("300.251.117-09", 46),
		   ("077.445.222-11", 49),
           ("900.136.987-15", 50),          
           ("098.765.432-11", 51),
           ("166.051.174-01", 52),
           ("300.945.310-80", 53),
		   ("228.001.874-37", 54),
           ("478.710.456-01", 55),
           ("547.171.991-65", 56),
           ("291.412.007-14", 57),
           ("710.710.819-13", 58),
           ("800.391.734-05", 59),
           ("016.366.256-09", 60),
           ("410.501.123-17", 60),
           ("448.111.345-09", 61),
           ("789.151.001-65", 61),
    	   ("011.056.914-31", 62);
           
/*17*/
insert into formPag(tipoPag, valor, ordemServico_idordemServico)
	values ("Débito", 550.0, 1),
           ("Crédito", 650, 3),
           ("Pix", 850, 4),
           ("Dinheiro", 450, 5),
           ("Boleto", 300, 7),
           ("Dinheiro", 350, 8),
           ("Dinheiro", 300, 9),
           ("Crédito", 380, 9),
		   ("Pix", 200, 10),
		   ("Crédito", 780, 12),           
		   ("Crédito", 950, 13),
           ("Crédito", 980, 15),
		   ("Crédito", 400, 16),
           ("Pix", 200, 16),           
           ("Crédito", 650, 17),
           ("Pix", 350, 18),
           ("Crédito", 500, 19),           
           ("Transferência bancária", 780, 20),
           ("Dinheiro", 300, 21),
           ("Crédito", 370, 21),
           ("Pix", 480, 22),           
           ("Crédito", 980, 23),
           ("Pix", 350, 24),
           ("Transferência bancária", 400, 25),
           ("Transferência bancária", 560, 27),
           ("Boleto", 520, 28),
           ("Débito", 380, 29),
           ("Pix", 400, 30),
           ("Crédito", 950, 31),
           ("Crédito", 720, 32),
           ("Débito", 600, 33),
           ("Boleto", 740, 34),
           ("Pix", 500, 35),
           ("Crédito", 750, 36),           
           ("Crédito", 850, 37),
           ("Crédito", 900, 38),
           ("Pix", 650, 39),
           ("Débito", 750, 40),
           ("Pix", 360, 41),           
           ("Pix", 300, 42),
           ("Pix", 150, 43),
           ("Pix", 250, 44),
           ("Crédito", 450, 45),
           ("Débito", 550, 46),
           ("Crédito", 980, 49),
           ("Débito", 650, 50),
           ("Crédito", 720, 51),
           ("Pix", 150, 52),
           ("Débito", 350, 53),
           ("Crédito", 450, 54),
           ("Pix", 200, 55),
           ("Débito", 250, 56),
           ("Crédito", 850, 57),
           ("Crédito", 620, 58),           
           ("Dinheiro", 300, 59),
           ("Boleto", 750, 60),
		   ("Crédito", 200, 61),
		   ("Boleto", 950, 62);    
 
 /*DQL*/ 

select * from cliente;                 /*1*/
select * from cliente_pessoa_fisica;   /*2*/
select * from cliente_pessoa_juridica; /*3*/
select * from veiculo;                 /*4*/    
select * from  mecanico;               /*5*/ 
select * from  endereco;               /*6*/
select * from telefone;                /*7*/
select * from  dependente;             /*8*/
select * from  servico;                /*9*/ 
select * from  tipoPeca;               /*10*/    
select * from  tipoPecaServico;        /*11*/
select * from compraPeca;              /*12*/
select * from  compraTiposPeca;        /*13*/
select * from  ordemServico;           /*14*/
select * from  osServico;              /*15*/ 
select * from mecanicoOS;              /*16*/  
select * from formPag;                 /*17*/

/*------------------------------------------DELETAR OU ATUALIZAR (DML)---------------------------------------------------------------------------*/

delete from tipoPeca
where idtipoPeca = 61;

delete from tipoPeca
where idtipoPeca = 60;

delete from compraTiposPeca
where comprapeca_idcomprapeca = 40 and tipoPeca_idtipoPeca = 33;

delete from compraTiposPeca
where comprapeca_idcomprapeca = 39 and tipoPeca_idtipoPeca = 18;

delete from cliente_pessoa_fisica
where cliente_idCliente = 1 and nome = "Adelson Nogueira";

delete from cliente_pessoa_fisica
where cliente_idCliente = 21;

delete from cliente
where idCliente = 22;

delete from cliente
where idCliente = 21;

update tipoPeca
set valor = 40.0
where idtipoPeca = 26;

update tipoPeca
set valor = 62.0
where idtipoPeca = 2;

update compraTiposPeca
set comprapeca_idcomprapeca = 40, tipoPeca_idtipoPeca = 33
where comprapeca_idcomprapeca = 40 and tipoPeca_idtipoPeca = 13;

update compraTiposPeca
set quantidade = 1
where comprapeca_idcomprapeca = 40 and tipoPeca_idtipoPeca = 17;

update tipoPeca
set valor = 100.0
where idtipoPeca = 59;

update cliente_pessoa_fisica
set email = "arthur.brito_@gmail.com"
where cliente_idCliente = 3 and cpf = "765.387.876-34";

update cliente_pessoa_fisica
set nome = "Camila Lins Silva"
where cliente_idCliente = 4;

update cliente_pessoa_juridica
set razaoSocial = "Servlight serviços Ltda", email = "servlight@servlight.com.br"
where cliente_idCliente = 6;

update veiculo
set ano = "2018", placa = "KEE-0064"
where cliente_idCliente = 1;

update veiculo
set ano = "2021"
where cliente_idCliente = 4;

update endereco
set numero = "10"
where mecanico_cpf = "066.154.874-37";

update endereco
set logadouro = "Av Recife", numero = "1001", bairro = "Areias", cep = "50772-600", complemento = "Ap 115 bloco B"
where mecanico_cpf = "300.945.310-80";

update dependente
set dataNasc = "2021-01-15"
where mecanico_cpf = "098.765.432-11";

update dependente
set emailDependente = "bruna.oliveira.bezerra@gmail.com"
where mecanico_cpf = "166.051.174-01" and cpf = "014.456.724-77";

/*----------------------------------------------  DQL -----------------------------------------------------------------------*/ 
/*É OBRIGATÓRIO USO DE JOIN E SUBSELECT NA MAIORIA DAS CONSULTAS MÍNIMO 20 SCRIPT*/

 /*1* Consulta os funcionários mecânicos ordenado pela cidade e bairro*/          
  select m.cpf 'CPF', m.nome 'Nome', e.bairro 'Bairro', e.cidade 'Cidade', e.uf 'UF'
		from mecanico m, endereco e
			where m.cpf = e.mecanico_cpf 
				order by cidade, bairro, nome;
                
  /*2* Consulta a quantidade de peças compradas pelos clientes pessoa física*/    
  select p.nome 'Nome',
		(select count(c.cliente_idCliente)
			from compraPeca c
				where c.cliente_idCliente = p.cliente_idCliente) as QtdPecas
					from cliente_pessoa_fisica p
						group by p.cliente_idCliente
                         order by nome;
                         
  /*3* Consulta a quantidade de peças compradas pelos clientes pessoa jurídica*/    
  select p.razaoSocial 'Razao Social',
		(select count(c.cliente_idCliente)
			from compraPeca c
				where c.cliente_idCliente = p.cliente_idCliente) as Qtd_Pecas
					from cliente_pessoa_juridica p
						group by p.cliente_idCliente
                           order by razaoSocial;   
                        
  /*4* Consulta a quantidade de dependentes por funcionário*/ 
    select m.nome 'Nome Funcionário',
		(select count(d.mecanico_cpf)
			from dependente d
				where d.mecanico_cpf = m.cpf) as Qtd_Dependentes
					from mecanico m
						group by m.cpf
                           order by nome;    

/*5* Consulta a quantidade de dependentes maior que(>)  1 por funcionário*/
 select f.nome 'Nome Func.', f.Qtd_Dependentes 'Qtd filh@s'
	from(select m.cpf, m.nome, 
			(select count(d.mecanico_cpf)
				from dependente d
					where d.mecanico_cpf = m.cpf) as Qtd_Dependentes
						from mecanico m ) as f
							where f.Qtd_Dependentes > 1 ;      
    
/*6* Consulta os clientes pessoa física o valor total de peças compradas*/
select p.nome 'Nome', c.tipo 'Tipo', sum(v.valor) "Total de Compra"
	from compraPeca v
    inner join cliente_pessoa_fisica p on v.cliente_idCliente = p.cliente_idCliente    
    inner join cliente c on v.cliente_idCliente = c.idCliente
		group by v.cliente_idCliente;
                                      
/*7*  Consulta os clientes pessoa jurídica o valor total de peças compradas*/
select p.razaoSocial 'Razao Social', c.tipo 'Tipo', sum(v.valor) "Total de Compra"
	from compraPeca v
    inner join cliente_pessoa_juridica p on v.cliente_idCliente = p.cliente_idCliente 
    inner join cliente c on v.cliente_idCliente = c.idCliente
		group by v.cliente_idCliente;
 
/*8* Consulta cada cliente pessoas física com a marca do veículo*/
select m.nome 'Nome', m.cpf 'CPF',  m.email 'E-mail', c.tipo 'Tipo', v.marca 'Marcado veículo', v.placa 'Placa'
		from cliente c
				inner join cliente_pessoa_fisica m on c.idCliente = m.cliente_idCliente
                inner join veiculo v on c.idCliente = v.cliente_idCliente
					order by nome;             
 
/*9* Consulta cada telefone dos funcionários */
select m.nome 'Nome', m.cpf 'CPF', e.uf 'UF', t.numeroTelefone 'Fone'
		from mecanico m
				inner join telefone t on m.cpf = t.mecanico_cpf                
                inner join endereco e on m.cpf = e.mecanico_cpf 
					order by nome;
 
/*10* Consulta os veiculos com sua ordem de serviço e status*/
select v.placa 'Placa', v.marca 'Marca', o.idOrdemServico 'OS', o.statusOs 'status'
		from veiculo v
				inner join ordemServico o on v.idVeiculo = o.veiculo_idVeiculo
					order by marca;
     
/*11* Consulta os ordem de serviços com os tipos de pagamento*/
select o.idOrdemServico 'OS', o.statusOs 'status', f.tipoPag 'Forma de Pagamento'
		from ordemServico o
				inner join formPag f on o.idOrdemServico = f.OrdemServico_idOrdemServico
					order by statusOs; 
 /*TESTE*/ 
 /*12* Consulta os ordem de serviços com os tipos de pagamento*/