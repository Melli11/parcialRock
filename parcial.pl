
% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de
% bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes,..., littoNebbia],hipodromoSanIsidro).
festival(popular, [damasGratis,nuevaLuna,losCharros],granRex).

festival(personalFest, [laRenga,losRedondos,sky],unicoLaPlata).

festival(rockNac,[damasGratis,nuevaLuna,losCharros],granRex).


% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las
% entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).
banda(damasGratis,argentina,10000).
banda(nuevaLuna,argentina,5000).
banda(losCharros,argentina,2000).
% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes:
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

entradaVendida(popular, plateaGeneral(zona2)).

entradaVendida(rockNac, campo).
entradaVendida(rockNac, plateaNumerada(1)).
entradaVendida(rockNac, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

% 1) Itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con
% el mismo nombre y las mismas bandas en el mismo orden.

itinerante(Festival):-
    festival(Festival, Bandas, Lugar),
    festival(Festival, Bandas, OtroLugar),
    Lugar \= OtroLugar.

% 2) careta/1: Decimos que un festival es careta si no tiene campo o si es el
% personalFest.

careta(Festival):-
    festival(Festival,_,_),
    not(entradaVendida(Festival, campo)).
    
careta(personalFest).

:-begin_tests(parcialRock).

test(careta,nondet):-
    careta(popular),
    careta(personalFest),
    not(careta(lollapalooza)).

:-end_tests(parcialRock).

% 3) nacAndPop/1: Un festival es nac&pop si no es careta y todas las bandas que tocan
% en él son de nacionalidad argentina y tienen popularidad mayor a 1000

nacAndPop(Festival):-
    festival(Festival,_,_),
    not(careta(Festival)),
    forall(festival(_,Bandas,_),(sonTodasArgentinasPopulares(Bandas,Popularidad),Popularidad>1000)).


% sonTodasArgentinasPopulares(Bandas,Popularidad):-
%     findall(,banda(Banda,argentina,Popularidad),Popularidad>1000,Lista)
    
%     banda(nombre,argentina, popularidad).


% festival(NombreDelFestival, Bandas, Lugar).

% :-begin_tests(parcialRock).

% test(nacAndPop,nondet):-
%     nacAndPop(rockNac).

% :-end_tests(parcialRock).

% festival(NombreDelFestival, Bandas, Lugar).
% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
% banda(gunsAndRoses, eeuu, 69420).