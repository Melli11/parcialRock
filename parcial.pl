
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

lugar(granRex, 2, 1500).

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
    festival(Festival,Bandas,_),
    not(careta(Festival)),
    forall(member(Banda,Bandas),(banda(Banda,argentina,Popularidad),Popularidad>1000)).


% auxiliar
bandasArgentinasSegunPopularidad(Festival,Banda,Popularidad):-
    festival(Festival,Bandas,_),
    banda(Banda,argentina,Popularidad),
    member(Banda,Bandas).
    

:-begin_tests(parcialRock).

test(nacAndPop,nondet):-
    nacAndPop(rockNac).

:-end_tests(parcialRock).

% 4) sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la
% capacidad del lugar donde se realizan.

sobrevendido(Festival):-
    festival(Festival,_,Lugar),
    lugar(Lugar,Capacidad,_),
    findall(Entrada,entradaVendida(Festival,Entrada),TotalVentas),
    length(TotalVentas,TotalEntradasVendidas),
    TotalEntradasVendidas > Capacidad.





% Indica la venta de una entrada de cierto tipo para el festival
% indicado.


% 5) recaudaciónTotal/2: Relaciona un festival con el total recaudado con la venta de
% entradas. Cada tipo de entrada se vende a un precio diferente:
% - El precio del campo es el precio base del lugar donde se realiza el festival.
% - La platea generales el precio base del lugar más el plus que se p aplica a la
% zona.
% - Las plateas numeradas salen el triple del precio base para las filas de atrás
% (>10) y 6 veces el precio base para las 10 primeras filas.
% Nota: no hace falta contemplar si es un festival itinerante.

recaudaciónTotal(Festival,TotalRecaudado):-
    festival(Festival,_,Lugar),
    findall(Precio,(entradaVendida(Festival, TipoDeEntrada),precioEntrada(TipoDeEntrada,Lugar,Precio)),Precios),
    sumlist(Precios,TotalRecaudado).
    
precioEntrada(campo,Lugar,Precio):-
    festival(_,_,Lugar),
    lugar(Lugar, _, Precio).  

precioEntrada(plateaGeneral(Zona),Lugar,Precio):-
    festival(_,_,Lugar),
    lugar(Lugar, _, PrecioBase),
    plusZona(Lugar, Zona, Recargo),
    Precio is PrecioBase + Recargo.

precioEntrada(plateaNumerada(Fila),Lugar,Precio):-
    festival(_,_,Lugar),
    lugar(Lugar, _, PrecioBase),
    Fila =<10,
    Precio is PrecioBase *6.

precioEntrada(plateaNumerada(Fila),Lugar,Precio):-
    festival(_,_,Lugar),
    lugar(Lugar, _, PrecioBase),
    Fila >10,
    Precio is PrecioBase *3.


delMismoPalo(UnaBanda,OtraBanda):-
    tocaronJuntas(UnaBanda,OtraBanda).

delMismoPalo(UnaBanda,OtraBanda):-
    tocaronJuntas(UnaBanda,TercerBanda),
    esMasPopular(TercerBanda,OtraBanda),
    delMismoPalo(TercerBanda,OtraBanda).

tocaronJuntas(UnaBanda,OtraBanda):-
    festival(_,Bandas,_),
    member(UnaBanda,Bandas),
    member(OtraBanda,Bandas),
    UnaBanda\=OtraBanda.

esMasPopular(UnaBanda,OtraBanda):-
    banda(UnaBanda,_,PopularidadA),
    banda(OtraBanda,_,PopularidadB),
    PopularidadA > PopularidadB.
    % festival(NombreDelFestival, Bandas, Lugar).
    % banda(nombre, nacionalidad, popularidad).


