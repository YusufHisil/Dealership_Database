drop trigger tr_after_insert_vanzare
DELIMITER //

CREATE TRIGGER tr_after_insert_vanzare
AFTER INSERT ON mydb.vanzare
FOR EACH ROW
BEGIN
  DECLARE v_nr_masini INT;
  
  SELECT nr_masini INTO v_nr_masini
  FROM mydb.inventar_masini
  WHERE id_masina = NEW.id_masina AND id_reprezentanta = (
    SELECT id_reprezentanta FROM mydb.vanzare WHERE idVanzare = NEW.idVanzare
  );
  
  UPDATE mydb.inventar_masini
  SET nr_masini = v_nr_masini - 1
  WHERE id_masina = NEW.id_masina AND id_reprezentanta = (
    SELECT id_reprezentanta FROM mydb.vanzare WHERE idVanzare = NEW.idVanzare
  );
END // DELIMITER ;

-- -------------------------------------------------------------------------------------------------------------
drop trigger generate_factura

DELIMITER //
CREATE TRIGGER generate_factura
AFTER INSERT ON programare_atelier FOR EACH ROW
BEGIN
	declare nume_client varchar(45);
    declare nume_reprezentanta varchar(45);
    
    select Nume into nume_client from client
    where New.idClient = client.idClient;
    
    select reprezentanta.Nume into nume_reprezentanta from reprezentanta, atelier
    where NEW.idAtelier = atelier.idAtelier 
		and reprezentanta.idReprezentanta = atelier.id_reprezentanta;

    INSERT INTO factura_serviciu (Nume_client, Nume_reprezentanta, Data_facturarii, Suma, id_programare)
    VALUES (nume_client, nume_reprezentanta, NOW(), 0, NEW.idProgramare_atelier);
END;
// DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------
drop trigger calculeaza_suma_totala

DELIMITER //

CREATE TRIGGER calculeaza_suma_totala
AFTER INSERT ON mydb.serviciu_programare
FOR EACH ROW
BEGIN
    DECLARE suma_totala DOUBLE;
    DECLARE expertiza INT;

    SELECT Nivel_exprtiza INTO expertiza
    FROM mecanic
    WHERE idMecanic = (SELECT idMecanic FROM programare_atelier WHERE idProgramare_atelier = NEW.id_programare);
    
    IF expertiza = 1 THEN
         set suma_totala = (SELECT Pret FROM lista_serviciu WHERE Serviciu = NEW.Nume_serviciu);
    ELSEIF expertiza = 2 THEN
         set suma_totala = (SELECT Pret * 1.10 FROM lista_serviciu WHERE Serviciu = NEW.Nume_serviciu);
    ELSE
        set suma_totala = (SELECT Pret * 1.15 FROM lista_serviciu WHERE Serviciu = NEW.Nume_serviciu);
    END IF;

    UPDATE factura_serviciu fs
    SET Suma = Suma + suma_totala
    WHERE id_programare = NEW.id_programare;
END //

DELIMITER ;
-- --------------------------------------------------------------------------------------------------------
drop trigger generate_factura_vanzare

DELIMITER //
CREATE TRIGGER generate_factura_vanzare
AFTER INSERT ON vanzare FOR EACH ROW
BEGIN
	declare nume_client varchar(45);
    declare nume_reprezentanta varchar(45);
    declare suma double;
    
    select Nume into nume_client from client
    where New.id_client = client.idClient;
    
    select Pret into suma from masina
    where new.id_masina=masina.idMasina;
    
    select reprezentanta.Nume into nume_reprezentanta from reprezentanta, masina, inventar_masini
    where NEW.id_masina = masina.idMasina  and inventar_masini.id_masina = masina.idMasina and reprezentanta.idReprezentanta = inventar_masini.id_reprezentanta;

    INSERT INTO factura_vanzare (Nume_client, Nume_reprezentanta, Data_facturarii, Suma, id_vanzare)
    VALUES (nume_client, nume_reprezentanta, NOW(), suma, NEW.idVanzare);
END;
// DELIMITER ;

-- --------------------------------------------------------------------------------------------------

drop trigger update_inventar_piese_dupa_programare_atelier

DELIMITER //
CREATE TRIGGER update_inventar_piese_dupa_programare_atelier
AFTER INSERT ON serviciu_programare FOR EACH ROW
BEGIN
    declare reprezentantaid int;
    declare piesaid int;
    declare quantity int;
    
    select id_reprezentanta into reprezentantaid from atelier,programare_atelier
    where new.id_programare=programare_atelier.idProgramare_atelier and programare_atelier.idAtelier = atelier.idAtelier;
    
    select Cantitate into quantity from piese_necesare_serviciu,lista_serviciu
    where new.Nume_serviciu=lista_serviciu.Serviciu and lista_serviciu.Serviciu=piese_necesare_serviciu.Serviciu;
    
    select idPiesa into piesaid from piese_necesare_serviciu,lista_serviciu
    where new.Nume_serviciu=lista_serviciu.Serviciu and lista_serviciu.Serviciu=piese_necesare_serviciu.Serviciu;
    
    update inventar_piese
    set Cantitate = Cantitate - quantity
    where idReprezentanta= reprezentantaid and idPiesa = piesaid;
END;
// DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------

drop trigger update_inventar_piese_dupa_comanda

DELIMITER //
CREATE TRIGGER update_inventar_piese_dupa_comanda
AFTER INSERT ON comanda FOR EACH ROW
BEGIN

update depozit_distribuitor
set Cantitate=Cantitate-new.cantitate
where new.idPiesa=depozit_distribuitor.idPiesa and new.idDistribuitor = depozit_distribuitor.id_distribuitor;

 IF EXISTS (SELECT 1 FROM inventar_piese WHERE idPiesa = new.idPiesa and new.id_reprezentanta = inventar_piese.idReprezentanta) THEN
        UPDATE inventar_piese
        SET Cantitate = Cantitate + new.cantitate
        WHERE new.idPiesa = inventar_piese.idPiesa and new.id_reprezentanta = inventar_piese.idReprezentanta;
    ELSE
        INSERT INTO inventar_piese (idReprezentanta, idPiesa, Cantitate)
        VALUES (new.id_reprezentanta, new.idPiesa, new.cantitate);
    END IF;
END;
// DELIMITER ;

-- ---------------------------------------------------------------------------------------------------


drop trigger insert_agent_vanzare

DELIMITER //
CREATE TRIGGER insert_agent_vanzare
AFTER INSERT ON angajat FOR EACH ROW
BEGIN
if new.rol='Agent_vanzari' then
	insert into agent_vanzare(id_Agent,idAngajat) values
    (new.idAngajat,new.idAngajat);
    end if;
END;
// DELIMITER ;

-- ---------------------------------------------------------------------------------------------------
drop trigger salariu_agent_vanzare

DELIMITER //
CREATE TRIGGER salariu_agent_vanzare
AFTER INSERT ON vanzare FOR EACH ROW
BEGIN
update angajat
set Salariu=Salariu+50 
where new.id_Agent = angajat.idAngajat;

END;
// DELIMITER ;

-- ---------------------------------------------------------------------------------------------------
drop trigger salariu_mecanic

DELIMITER //
CREATE TRIGGER salariu_mecanic
AFTER INSERT ON programare_atelier FOR EACH ROW
BEGIN
    DECLARE idang INT;
    
    SELECT mecanic.idAngajat INTO idang
    FROM mecanic, angajat
    WHERE NEW.idMecanic = mecanic.idMecanic AND mecanic.idAngajat = angajat.idAngajat;

    UPDATE angajat
    SET Salariu = Salariu + 50
    WHERE idang = angajat.idAngajat;
END;
//
DELIMITER ;


-- ---------------------------------------------------------------------------------------------------
