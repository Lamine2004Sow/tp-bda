import itertools
#Exercice 4:Dépendances Fonctionnelles

#Données de l'énoncé
myrelations = [
    {'A', 'B', 'C', 'G', 'H', 'I'},
    {'X', 'Y'}
]

mydependencies = [
    [{'A'}, {'B'}],        # A -> B
    [{'A'}, {'C'}],        # A -> C
    [{'C', 'G'}, {'H'}],   # CG -> H
    [{'C', 'G'}, {'I'}],   # CG -> I
    [{'B'}, {'H'}]         # B -> H
]

#1.Ecrire une proc´edure qui permet de prendre en param`etre une liste de d´ependances fonctionnelles et les affiche

def printDependencies (F:"list of dependencies "):
	for alpha, beta in F :
		print ("\t",alpha ," --> " ,beta)


#2.Ecrire une proc´edure qui permet de prendre en param`etre un ensemble de relations T et les affiche.

def printRelations (T:"list of relations" ):
		for R in T :
			print ("\t" , R)
			
#3. ´Ecrire une fonction qui, prenant en param`etre un ensemble inputset, revoie tous ces sous-ensembles. Rappelons qu’un sous-ensemble S d’un ensemble E est un ensemble tel que S ⊆ E. L’ensemble qui a pour ´el´ements tous les sous-ensemble de E est not´e P (E). Et card(P (E)) = 2n, o`u n = card(E) (la cardinalit´e de E). N’oubliez pas l’instruction permettant d’importer itertools.


def powerSet (inputset:"set"):
	_result =[]
	for r in range (1,len (inputset)+1):
		_result += map (set ,itertools.combinations(inputset,r))

	return _result


#4. ´Ecrire une fonction qui permet, ´etant donn´e un ensemble de d´ependances fonctionnelles F et un ensemble d’attributs K, de retourner la fermeture (clˆoture) de K.


def get_attribute_closure(dependencies: list, attributes: set) -> set:
    closure = set(attributes)
    
    while True:
        previous_size = len(closure)
        
        for left_side, right_side in dependencies:
            if left_side.issubset(closure):
                closure = closure | right_side 
        if len(closure) == previous_size:
            break
            
    return closure
    
    
# 5. ´Ecrire une fonction qui permet, ´etant donn´e un ensemble de d´ependances fonctionnelles F , de retourner la clˆoture de F . Rappel : la clˆoture de F est un ensemble constitu´e de toutes les d´ependances fonctionnelles que l’on peut d´eduire de F .

def get_dependencies_closure(dependencies: list) -> list:

    all_attributes =set()
    for left_side,right_side in dependencies:
        all_attributes =all_attributes|left_side|right_side
        
    closure_f= []
    
    for potential_left in powerSet(all_attributes):
        

        determined_attributes=get_attribute_closure(dependencies, potential_left)

        for potential_right in powerSet(determined_attributes
            closure_f.append([set(potential_left), set(potential_right)])
            
    return closure_f

#6. Ecrire une fonction qui permet, ´etant donn´ee un ensemble de d´ependances fonctionnelles F et deux ensembles d’attributs α et β , de retourner vrai si α d´etermine fonctionnement β.



