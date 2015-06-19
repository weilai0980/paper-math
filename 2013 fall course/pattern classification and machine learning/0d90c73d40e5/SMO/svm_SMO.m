% A  Fseudocode for SMO Regression
% 这个程序好像是伪码，部分地方表述的不是规范的matlab
target =desired output vector
point =raining point matrix

procedure takeStep(i1,i2)
if (i1 == i2)  return 0
alphas, alphal* = Lagrange multipliers for i1
yl = target[i1]
phi1 = SVM output on point[ii] - yl (in error cache)
ki1 = kernel(point[i1],point[i1])
k12 = kernel(point[i1],point[i2])
k22 = kernel(point[i2],point[i2])
eta = 2*k12-k11-k22
gamma = alphal - alphal* + alpha2 - alpha2*

% we assume eta > 0. otherwise one has to repeat the complete
% reasoning similarly (compute objective function for L and H 
% and decide which one is largest


case1 = case2 = case3 = case4= finished = 0
alphalold =alphal, alphalold*= alphal*
alphalold =alpha2, alpha2old*= alpha2*
delta-phi =phil - phi2

while !finished
% this loop is passed at most three times
% case variables needed to avoid attempting small changes twice
if  (casel == 0) &&
	(alphas > 0 || (alphal* ==0 && deltaphi > 0)) &&
	(alpha2 > 0 || (alpha2* ==0 && deltaphi < 0))
compute L, H (wrt. alpha1, alpha2)
if  L<H
	a2 = alpha2 - deltaphi/eta
	a2 = min(a2, H)
	a2 = max(L, a2)
	al = alphal - (a2 - alpha2)
	update alphal, alpha2 if change is larger than some eps
else
finished = 1
endif
cases = 1;
elseif (case2 == 0) &&
(alphal > 0 ||  (alphal* == 0 && deltaphi > 2 epsilon)) &&
(alpha2* > 0 || (alpha2 == 0 && deltaphi > 2 epsilon))
compute L, H (wrt. alphal, alpha2*)

if  L<H
	a2 = alpha2* + (deltaphi - 2 epsilon)/eta
	a2 = min(a2, H)
	a2 = max(L, a2)
	al = alpha1 + (a2 - alpha2*)
    update alphas, alpha2* if change is larger than same eps
else
finished = i
endif
case2 = 1

elseif  (case3 == 0) &&
		(alphai* > 0 || (alphai == 0 && deltaphi < 2 epsilon)) &&
		(alpha2 > 0 || (alpha2* == 0 && deltaphi < 2 epsilon))
		compute L, H (wrt. alphai*, alpha2)
if L<H
a2 = alpha2 - (deltaphi - 2*epsilon)/eta
a2 = min(a2, H)
a2 = max(L, a2)
al = alphai* +(a2 - alpha2)
update alphai*, alpha2 if change is larger than same eps
else
finished = 1
endif
case3 = 1;

elseif (case4 == 0) &&
(alphai* > 0 || (alphai == 0 && deltaphi < 0)) &&
(alpha2* > 0 || (alpha2 == 0 && deltaphi > 0))
compute L, H (wrt. alphai*, alpha2*)
if  L<H
	a2 = alpha2* t deltaphi/eta
	a2 = min(a2, H)
	a2 = max(L, a2)
	al = alphai* - (a2 - alpha2*)
	update alphai*, alpha2* if change is larger than same eps
else
	finished = 1
	endif
	case4 = 1
else
	finished=1
endif
    update deltaphi 
endwhile

Update threshold to reflect change in Lagrange multipliers
Update error cache using new Lagrange multipliers 
if changes in alphal(*),alpha2(*) are larger than same eps
    return 1
else
return 0
endif
endprocadure

procedure examineExample(i2)
y2=target[i2]
alpha2, alpha2* = Lagrange multipliers for i2
C2,C2*= Constraints for i2
phi2 = SVM output on point[i2] - y2 (in error cache)

if  ((phi2 > epsilon && alpha2* < C2*)  ||
	(phi2 < epsilon k& alpha2* > 0 ||
	(-phi2 > epsilon && alpha2  < C2) ||
	(-phi2 > epsilon && alpha2  > 0  ))
    if (number of non-zero & non-C alpha >1) 
    il = identity of current alpha
    if takaStep(i1,i2) return 1
endif
loop aver all non-zero and non-C alpha, random start
    il = identity of current alpha
    if takaStep(i1,i2) return 1
endloflp
loop aver all possible il, with random start
	il = loop variable
	if takaStep(ii,i2) return 1
endloflp
endif
return 0
andprocedure

main routine:
	initialize alpha and alpha* array to all zero
	initialize threshold to zero
	numChanged = 0
	examineAll = 1
	SigFig = -100
	LoopCounter = 0
    
	while ((numChanged > 0 | examineAll) | (SigFig < 3))
		Loopcounter++
		numChanged = 0;
		if (examineAll)
			loop I over all training examples
				numChanged += examineExample(I)
		else
			loop I over examples where alpha is not 0 & not C
            numChanged += examineExample(I)
		endif
		if (mod(LoopCounter, 2) == 0)
			MinimumMumChanged = max(1, 0.1*NumSamples)
		else
			MinimumMumChanged = 1
		endif
		if (examineAll == 1)
			examineAll = 0
		elseif (numChanged e MinimumNumChanged)
			examineAll = 1
		endif
	endwhile
endmain