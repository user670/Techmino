local noKick,noKick_180,pushZero do
	local zero={0,0}
	local Zero={zero}
	noKick={[01]=Zero,[10]=Zero,[03]=Zero,[30]=Zero,[12]=Zero,[21]=Zero,[32]=Zero,[23]=Zero}
	noKick_180={[01]=Zero,[10]=Zero,[03]=Zero,[30]=Zero,[12]=Zero,[21]=Zero,[32]=Zero,[23]=Zero,[02]=Zero,[20]=Zero,[13]=Zero,[31]=Zero}
	function pushZero(t)
		for _,L in next,t do
			if type(L)=="table"then
				for _,v in next,L do
					if not v[1]or v[1][1]~=0 or v[1][2]~=0 then
						table.insert(v,1,zero)
					end
				end
			end
		end
	end
end

local collect do
	local map={}
	for x=-3,3 do map[x]={}for y=-3,3 do map[x][y]={x,y}end end
	function collect(T)--Make all vec point to the same vec
		if type(T)=="table"then
			for _,t in next,T do
				for k,vec in next,t do
					t[k]=map[vec[1]][vec[2]]
				end
			end
		end
	end
end

local function C_sym(L)--Use this if the block is centrosymmetry, *PTR!!!
	L[23]=L[01]L[32]=L[10]
	L[21]=L[03]L[12]=L[30]
	L[20]=L[02]L[31]=L[13]
end
local function flipList(O)--Use this to copy a symmetry list
	if not O then return end
	local L={}
	for i=1,#O do
		L[i]={-O[i][1],O[i][2]}
	end
	return L
end
local function reflect(a)
	local b={}
	b[03]=flipList(a[01])
	b[01]=flipList(a[03])
	b[30]=flipList(a[10])
	b[32]=flipList(a[12])
	b[23]=flipList(a[21])
	b[21]=flipList(a[23])
	b[10]=flipList(a[30])
	b[12]=flipList(a[32])
	b[02]=flipList(a[02])
	b[20]=flipList(a[20])
	b[31]=flipList(a[13])
	b[13]=flipList(a[31])
	return b
end

local TRS
do
	local OspinList={
		{111,5,2, 0,-1,0},{111,5,2,-1,-1,0},{111,5,0,-1, 0,0},--T
		{333,5,2,-1,-1,0},{333,5,2, 0,-1,0},{333,5,0, 0, 0,0},--T
		{313,1,2,-1, 0,0},{313,1,2, 0,-1,0},{313,1,2, 0, 0,0},--Z
		{131,2,2, 0, 0,0},{131,2,2,-1,-1,0},{131,2,2,-1, 0,0},--S
		{331,3,2, 0,-1,0},{113,3,0, 0, 0,0},{113,3,2,-1, 0,0},--J
		{113,4,2,-1,-1,0},{331,4,0,-1, 0,0},{331,4,2, 0, 0,0},--L
		{222,7,2,-1, 0,1},{222,7,2,-2, 0,1},{222,7,2, 0, 0,1},--I
		{121,6,0, 1,-1,2},{112,6,0, 2,-1,2},{122,6,0, 1,-2,2},--O
		{323,6,0,-1,-1,2},{332,6,0,-2,-1,2},{322,6,0,-1,-2,2},--O
	}--{keys, ID, dir, dx, dy, freeLevel (0=immovable,1=L+R immovable,2=free)}
	local XspinList={
		{{ 1,-1},{ 1, 0},{ 1, 1},{ 1,-2},{ 1, 2}},
		{{ 0,-1},{ 0,-2},{ 0, 1},{ 0,-2},{ 0, 2}},
		{{-1,-1},{-1, 0},{-1, 1},{-1,-2},{-1, 2}},
	}
	TRS={
		{
			[01]={{-1, 0},{-1, 1},{ 0,-2},{-1, 2},{ 0, 1}},
			[10]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1,-2},{ 1,-2}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-2},{ 1,-1},{ 1,-2}},
			[30]={{-1, 0},{-1,-1},{ 0, 2},{-1, 2},{ 0,-1}},
			[12]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1, 2}},
			[21]={{-1, 0},{-1, 1},{ 0,-2},{-1,-2}},
			[32]={{-1, 0},{-1,-1},{ 0, 2},{-1, 2}},
			[23]={{ 1, 0},{ 1, 1},{ 0,-2},{ 1,-2}},
			[02]={{ 1, 0},{-1, 0},{ 0,-1},{ 0, 1}},
			[20]={{-1, 0},{ 1, 0},{ 0, 1},{ 0,-1}},
			[13]={{ 0,-1},{ 0, 1},{-1, 0},{ 0,-2}},
			[31]={{ 0, 1},{ 0,-1},{ 1, 0}},
		},--Z
		false,--S
		{
			[01]={{-1, 0},{-1, 1},{ 1, 0},{ 0,-2},{ 1, 1}},
			[10]={{ 1, 0},{ 1,-1},{-1, 0},{ 0, 2},{ 1, 2}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-2},{ 1,-2},{ 1,-1},{ 0, 1}},
			[30]={{-1, 0},{-1,-1},{ 0, 2},{-1, 2},{ 0,-1},{-1, 1}},
			[12]={{ 1, 0},{ 1,-1},{ 1, 1},{-1, 0},{ 0,-1},{ 0, 2},{ 1, 2}},
			[21]={{-1, 0},{-1, 1},{-1,-1},{ 1, 0},{ 0, 1},{ 0,-2},{-1,-2}},
			[32]={{-1, 0},{-1,-1},{ 1, 0},{ 0, 2},{-1, 2},{-1, 1}},
			[23]={{ 1, 0},{ 1,-1},{-1, 0},{ 1, 1},{ 0,-2},{ 1,-2}},
			[02]={{-1, 0},{ 1, 0},{ 0,-1},{ 0, 1}},
			[20]={{ 1, 0},{-1, 0},{ 0, 1},{ 0,-1}},
			[13]={{ 0,-1},{ 0, 1},{ 1, 0}},
			[31]={{ 0, 1},{ 0,-1},{-1, 0}},
		},--J
		false,--L
		{
			[01]={{-1, 0},{-1, 1},{ 0,-2},{-1,-2},{ 0, 1}},
			[10]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1, 2},{ 0,-1}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-2},{ 1,-2},{ 0, 1}},
			[30]={{-1, 0},{-1,-1},{ 0, 2},{-1, 2},{ 0,-1}},
			[12]={{ 1, 0},{ 1,-1},{ 0,-1},{-1,-1},{ 0, 2},{ 1, 2}},
			[21]={{-1, 0},{ 0,-2},{-1,-2},{ 1, 1}},
			[32]={{-1, 0},{-1,-1},{ 0,-1},{ 1,-1},{ 0, 2},{-1, 2}},
			[23]={{ 1, 0},{ 0,-2},{ 1,-2},{-1, 1}},
			[02]={{-1, 0},{ 1, 0},{ 0, 1}},
			[20]={{ 1, 0},{-1, 0},{ 0,-1}},
			[13]={{ 0,-1},{ 0, 1},{ 1, 0},{ 0,-2},{ 0, 2}},
			[31]={{ 0,-1},{ 0, 1},{-1, 0},{ 0,-2},{ 0, 2}},
		},--T
		function(P,d)
			if P.gameEnv.easyFresh then
				P:freshBlock("fresh")
			end
			if P.gameEnv.ospin then
				local x,y=P.curX,P.curY
				if y==P.ghoY and((P:solid(x-1,y)or P:solid(x-1,y+1)))and(P:solid(x+2,y)or P:solid(x+2,y+1))then
					if P.sound then SFX.play("rotatekick",nil,P:getCenterX()*.15)end
					P.spinSeq=P.spinSeq%100*10+d
					if P.spinSeq<100 then return end
					for i=1,#OspinList do
						local L=OspinList[i]
						if P.spinSeq==L[1]then
							local id,dir=L[2],L[3]
							local bk=BLOCKS[id][dir]
							x,y=P.curX+L[4],P.curY+L[5]
							if not P:ifoverlap(bk,x,y)and(L[6]>0 or P:ifoverlap(bk,x-1,y)and P:ifoverlap(bk,x+1,y))and(L[6]==2 or P:ifoverlap(bk,x,y-1))and P:ifoverlap(bk,x,y+1)then
								local C=P.cur
								C.id=id
								C.bk=bk
								P.curX,P.curY=x,y
								P.cur.dir,P.cur.sc=dir,SCS[id][dir]
								P.spinLast=2
								P.stat.rotate=P.stat.rotate+1
								P:freshBlock("move")
								P.spinSeq=0
								return
							end
						end
					end
				else
					if P.sound then SFX.play("rotate",nil,P:getCenterX()*.15)end
					P.spinSeq=0
				end
			else
				if P.sound then SFX.play("rotate",nil,P:getCenterX()*.15)end
			end
		end,--O
		{
			[01]={{ 0, 1},{ 1, 0},{-2, 0},{-2,-1},{ 1, 2}},
			[10]={{ 2, 0},{-1, 0},{-1,-2},{ 2, 1},{ 0, 1}},
			[03]={{ 0, 1},{-1, 0},{ 2, 0},{ 2,-1},{-1, 2}},
			[30]={{-2, 0},{ 1, 0},{ 1,-2},{-2, 1},{ 0, 1}},
			[12]={{-1, 0},{ 2, 0},{ 2,-1},{ 0,-1},{-1, 2}},
			[21]={{-2, 0},{ 1, 0},{ 1,-2},{-2, 1},{ 0, 1}},
			[32]={{ 1, 0},{-2, 0},{-2,-1},{ 0,-1},{ 1, 2}},
			[23]={{ 2, 0},{-1, 0},{-1,-2},{ 2, 1},{ 0, 1}},
			[02]={{-1, 0},{ 1, 0},{ 0,-1},{ 0, 1}},
			[20]={{ 1, 0},{-1, 0},{ 0, 1},{ 0,-1}},
			[13]={{ 0,-1},{-1, 0},{ 1, 0},{ 0, 1}},
			[31]={{ 0,-1},{ 1, 0},{-1, 0},{ 0, 1}},
		},--I
		{
			[01]={{-1, 0},{ 0, 1},{ 1, 1},{ 0,-3},{ 0, 2},{ 0, 3},{-1, 2}},
			[10]={{ 1, 0},{ 0,-1},{-1,-1},{ 0,-2},{ 0,-3},{ 0, 3},{ 1,-2}},
			[03]={{ 1, 0},{ 0,-3},{ 0, 1},{ 0, 2},{ 0, 3},{ 1, 2}},
			[30]={{-1, 0},{ 0, 1},{ 0,-2},{ 0,-3},{ 0, 3},{-1,-2}},
		},--Z5
		false,--S5
		{
			[01]={{-1, 0},{-1, 1},{ 0,-2},{-1,-2},{-1,-1},{ 0, 1}},
			[10]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1, 2},{ 0,-1},{ 1, 1}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-2},{-1, 1}},
			[30]={{-1, 0},{-1,-1},{ 0, 2},{-1, 2}},
			[12]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1, 2},{ 1, 1}},
			[21]={{-1, 0},{-1,-1},{-1, 1},{ 0,-2},{-1,-2},{-1,-1}},
			[32]={{-1, 0},{-1,-1},{-1, 1},{ 1, 0},{ 0,-1},{ 0, 2},{-1, 2}},
			[23]={{ 1, 0},{ 1, 1},{-1, 0},{ 0,-2},{ 1,-2}},
			[02]={{-1, 0},{ 0,-1},{ 0, 1}},
			[20]={{ 1, 0},{ 0, 1},{ 0,-1}},
			[13]={{ 1, 0},{ 0, 1},{-1, 0}},
			[31]={{-1, 0},{ 0,-1},{ 1, 0}},
		},--P
		false,--Q
		{
			[01]={{-1, 0},{ 1, 0},{-1, 1},{ 0,-2},{ 0,-3}},
			[10]={{ 1, 0},{ 1,-1},{-1, 0},{ 0, 2},{ 0, 3}},
			[03]={{ 1, 0},{ 1,-1},{ 0, 1},{ 0,-2},{ 0,-3}},
			[30]={{-1, 1},{ 1, 0},{ 0,-1},{ 0, 2},{ 0, 3}},
			[12]={{ 1, 0},{ 0,-1},{-1, 0},{ 0, 2}},
			[21]={{-1, 0},{ 0, 1},{ 1, 0},{ 0,-2}},
			[32]={{-1, 0},{ 0, 1},{-1, 1},{ 1, 0},{ 0, 2},{-2, 0}},
			[23]={{ 1, 0},{ 1,-1},{ 0,-1},{-1, 0},{ 0,-2},{ 2, 0}},
			[02]={{ 1, 0},{-1, 0},{-1,-1}},
			[20]={{-1, 0},{ 1, 0},{ 1, 1}},
			[13]={{ 0,-1},{-1, 1},{ 0, 1}},
			[31]={{ 0,-1},{ 1,-1},{ 0, 1}},
		},--F
		false,--E
		{
			[01]={{ 0,-1},{-1,-1},{ 1, 1},{ 1, 0},{ 1,-3},{-1, 0},{ 0, 2},{-1, 2}},
			[10]={{ 1, 0},{ 0,-1},{-1,-1},{ 0,-2},{-1, 1},{ 0,-3},{ 1,-2},{ 0, 1}},
			[03]={{ 0,-1},{ 1,-1},{-1,-1},{-1, 0},{-1,-3},{ 1, 0},{ 0, 2},{ 1, 2}},
			[30]={{-1, 0},{ 0,-1},{ 1,-1},{ 0,-2},{ 1, 1},{ 0,-3},{-1,-2},{ 0, 1}},
			[12]={{ 1, 0},{-1, 0},{ 0,-2},{ 0,-3},{ 0, 1},{-1, 1}},
			[21]={{ 1,-1},{-1, 0},{ 1, 0},{ 0,-1},{ 0, 2},{ 0, 3}},
			[32]={{-1, 0},{ 1, 0},{ 0,-2},{ 0,-3},{ 0, 1},{ 1, 1}},
			[23]={{-1,-1},{ 1, 0},{-1, 0},{ 0,-1},{ 0, 2},{ 0, 3}},
			[02]={{ 0, 1},{ 0,-1},{ 0, 2}},
			[20]={{ 0,-1},{ 0, 1},{ 0,-2}},
			[13]={{ 1, 0},{-1, 1},{-2, 0}},
			[31]={{-1, 0},{ 1, 1},{ 2, 0}},
		},--T5
		{
			[01]={{-1, 0},{-1, 1},{ 0,-2},{-1,-2}},
			[10]={{ 1, 0},{ 1,-1},{ 0, 2},{ 1, 2}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-2},{ 1,-2}},
			[30]={{-1, 0},{-1,-1},{ 0,-2},{-1, 2}},
			[12]={{ 1, 0},{ 1,-1},{ 1, 1}},
			[21]={{-1,-1},{-1, 1},{-1,-1}},
			[32]={{-1, 0},{-1,-1},{-1, 1}},
			[23]={{ 1,-1},{ 1, 1},{ 1,-1}},
			[02]={{ 0, 1}},
			[20]={{ 0,-1}},
			[13]={{ 0,-1},{ 0, 1},{ 1, 0}},
			[31]={{ 0,-1},{ 0, 1},{-1, 0}},
		},--U
		{
			[01]={{ 0, 1},{-1, 0},{ 0,-2},{-1,-2}},
			[10]={{ 0, 1},{ 1, 0},{ 0,-2},{ 1,-2}},
			[03]={{ 0,-1},{ 0, 1},{ 0, 2}},
			[30]={{ 0,-1},{ 0, 1},{ 0,-2}},
			[12]={{ 0,-1},{ 0, 1}},
			[21]={{ 0,-1},{ 0,-2}},
			[32]={{ 1, 0},{-1, 0}},
			[23]={{-1, 0},{ 1, 0}},
			[02]={{-1, 1},{ 1,-1}},
			[20]={{ 1,-1},{-1, 1}},
			[13]={{ 1, 1},{-1,-1}},
			[31]={{-1,-1},{ 1, 1}},
		},--V
		{
			[01]={{ 0,-1},{-1, 0},{ 1, 0},{ 1,-1},{ 0, 2}},
			[10]={{ 0,-1},{-1,-1},{ 0, 1},{ 0,-2},{ 1,-2},{ 0, 2}},
			[03]={{ 1, 0},{ 1, 1},{ 0,-1},{ 0,-2},{ 0,-3},{ 1,-1},{ 0, 1},{ 0, 2},{ 0, 3}},
			[30]={{-1, 0},{-1, 1},{ 0,-1},{ 0,-2},{ 0,-3},{-1,-1},{ 0, 1},{ 0, 2},{ 0, 3}},
			[12]={{ 1, 0},{ 0,-1},{-2, 0},{ 1, 1},{-1, 0},{ 0, 1},{-1,-1}},
			[21]={{-1, 0},{ 0,-1},{ 2, 0},{-1, 1},{ 1, 0},{ 0, 1},{ 1,-1}},
			[32]={{ 0,-1},{ 1, 0},{ 0, 1},{-1, 0},{-1,-1},{ 0, 2}},
			[23]={{ 0,-1},{ 1,-1},{ 0, 1},{ 0,-2},{-1,-2},{ 0, 2}},
			[02]={{ 0,-1},{-1, 0}},
			[20]={{ 0, 1},{ 1, 0}},
			[13]={{ 0, 1},{-1, 0}},
			[31]={{ 0,-1},{ 1, 0}},
		},--W
		function(P,d)
			if P.type=="human"then SFX.play("rotate",nil,P:getCenterX()*.15)end
			local kickData=XspinList[d]
			for test=1,#kickData do
				local x,y=P.curX+kickData[test][1],P.curY+kickData[test][2]
				if not P:ifoverlap(P.cur.bk,x,y)then
					P.curX,P.curY=x,y
					P.spinLast=1
					P:freshBlock("move")
					P.stat.rotate=P.stat.rotate+1
					return
				end
			end
			P:freshBlock("fresh")
		end,--X
		{
			[01]={{-1, 0},{-1, 1},{ 0,-3},{-1, 1},{-1, 2},{ 0, 1}},
			[10]={{-1, 0},{ 1,-1},{ 0, 3},{ 1,-1},{ 1,-2},{ 0, 1}},
			[03]={{ 0,-1},{ 1,-1},{-1, 0},{ 1, 1},{ 0,-2},{ 1,-2},{ 0,-3},{ 1,-3},{-1, 1}},
			[30]={{ 0, 1},{-1, 1},{ 1, 0},{-1,-1},{ 0, 2},{-1, 2},{ 0, 3},{-1, 3},{ 1,-1}},
			[12]={{ 1, 0},{ 1,-1},{ 0,-1},{ 1,-2},{ 0,-2},{ 1, 1},{-1, 0},{ 0, 2},{ 1, 2}},
			[21]={{-1, 0},{-1, 1},{ 0, 1},{-1, 2},{ 0, 2},{-1,-1},{ 1, 0},{ 0,-2},{-1,-2}},
			[32]={{-1, 0},{-1, 1},{-1,-1},{ 1, 0},{ 0, 2},{-1, 2},{ 0,-2}},
			[23]={{ 1, 0},{ 1,-1},{ 1, 1},{-1, 0},{ 0,-2},{ 1,-2},{ 0, 2}},
			[02]={{ 0,-1},{ 1,-1},{-1, 0},{ 2,-1},{ 0, 1}},
			[20]={{ 0, 1},{-1, 1},{ 1, 0},{-2, 1},{ 0,-1}},
			[13]={{-1, 0},{-1,-1},{ 0, 1},{-1,-2}},
			[31]={{ 1, 0},{ 1, 1},{ 0,-1},{ 1, 2}},
		},--J5
		false,--L5
		{
			[01]={{-1, 0},{-1, 0},{-1, 1},{ 1, 0},{-1, 2},{-1,-1},{ 0,-3},{ 0, 1}},
			[10]={{-1, 0},{ 1, 0},{ 1,-1},{ 1, 0},{ 1,-2},{ 1, 1},{ 0, 3},{ 0, 1}},
			[03]={{ 0,-1},{ 1, 0},{ 1,-1},{-1, 0},{ 1, 1},{ 0,-2},{ 1,-2},{ 0,-3},{ 1,-3},{-1, 1}},
			[30]={{ 0, 1},{-1, 0},{-1, 1},{ 1, 0},{-1,-1},{ 0, 2},{-1, 2},{ 0, 3},{-1, 3},{ 1,-1}},
			[12]={{ 1, 0},{ 1,-1},{ 0,-1},{ 1,-2},{ 0,-2},{ 1, 1},{-1, 0},{ 0, 2},{ 1, 2}},
			[21]={{-1, 0},{-1, 1},{ 0, 1},{-1, 2},{ 0, 2},{-1,-1},{ 1, 0},{ 0,-2},{-1,-2}},
			[32]={{ 0,-1},{-1, 0},{-1, 1},{-1,-1},{ 1, 0},{ 0, 2},{-1, 2},{ 0,-2}},
			[23]={{ 0, 1},{ 1, 0},{ 1,-1},{ 1, 1},{-1, 0},{ 0,-2},{ 1,-2},{ 0, 2}},
			[02]={{ 0,-1},{ 1,-1},{-1, 0},{ 2,-1},{ 0, 1}},
			[20]={{ 0, 1},{-1, 1},{ 1, 0},{-2, 1},{ 0,-1}},
			[13]={{-1, 0},{-1,-1},{ 0, 1},{-1,-2}},
			[31]={{ 1, 0},{ 1, 1},{ 0,-1},{ 1, 2}},
		},--R
		false,--Y
		{
			[01]={{-1, 0},{-1, 1},{ 0, 1},{ 1, 0},{-1, 2},{-2, 0},{ 0,-2}},
			[10]={{ 1, 0},{-1, 0},{ 0,-1},{ 1,-1},{ 1,-2},{ 2, 0},{ 0, 2}},
			[03]={{-1, 0},{ 1,-1},{ 0,-2},{ 0,-3},{ 1, 0},{ 1,-2},{ 1,-3},{ 0, 1},{-1, 1}},
			[30]={{-1, 0},{ 1,-1},{ 1,-2},{ 1, 0},{ 0,-2},{ 1,-3},{-1, 2},{ 0, 3},{-1, 3}},
			[12]={{-1, 0},{ 1,-1},{-1,-1},{ 1,-2},{ 1, 0},{ 0,-2},{ 1,-3},{-1, 2},{ 0, 3},{-1, 3}},
			[21]={{-1, 0},{ 1,-1},{ 1, 1},{ 0,-2},{ 0,-3},{ 1, 0},{ 1,-2},{ 1,-3},{ 0, 1},{-1, 1}},
			[32]={{-1, 0},{ 0,-1},{-1,-2},{ 1,-1},{ 1, 0},{ 1, 1},{ 0, 2},{ 0, 3}},
			[23]={{ 0,-2},{ 0,-3},{ 1, 2},{ 1, 0},{ 0, 1},{-1, 1},{ 0,-1},{ 0, 2}},
			[02]={{-1, 0},{ 0, 2},{ 0,-1}},
			[20]={{ 1, 0},{ 0,-2},{ 0, 1}},
			[13]={{-1, 0},{-1,-1},{ 0, 1},{ 1, 2}},
			[31]={{ 1, 0},{ 1, 1},{ 0,-1},{-1,-2}},
		},--N
		false,--H
		{
			[01]={{ 1,-1},{ 1, 0},{ 1, 1},{ 0, 1},{-1, 1},{-1, 0},{-1,-1},{ 0,-1},{ 0,-2},{-2,-1},{-2,-2},{ 2, 0},{ 2,-1},{ 2,-2},{ 1, 2},{ 2, 2},{-1, 2},{-2, 2}},
			[10]={{-1, 0},{-1,-1},{ 0,-1},{ 1,-1},{-2,-2},{-2,-1},{-2, 0},{-1,-2},{ 0,-2},{ 1,-2},{ 2,-2},{-1, 1},{-2, 1},{-2, 2},{ 1, 0},{ 2, 0},{ 2,-1},{ 0, 1},{ 1,-1},{ 2,-2}},
			[03]={{-1,-1},{-1, 0},{-1, 1},{-0, 1},{ 1, 1},{ 1, 0},{ 1,-1},{-0,-1},{-0,-2},{ 2,-1},{ 2,-2},{-2, 0},{-2,-1},{-2,-2},{-1, 2},{-2, 2},{ 1, 2},{ 2, 2}},
			[30]={{ 1, 0},{ 1,-1},{-0,-1},{-1,-1},{ 2,-2},{ 2,-1},{ 2, 0},{ 1,-2},{-0,-2},{-1,-2},{-2,-2},{ 1, 1},{ 2, 1},{ 2, 2},{-1, 0},{-2, 0},{-2,-1},{ 0, 1},{-1,-1},{-2,-2}},
		},--I5
		{
			[01]={{-1, 0},{-1,-1},{ 1, 1},{-1, 1}},
			[10]={{-1, 0},{ 1, 0},{-1,-1},{ 1, 1}},
			[03]={{ 1, 0},{ 1,-1},{-1, 1},{ 1, 1}},
			[30]={{ 1, 0},{-1, 0},{ 1,-1},{-1, 1}},
		},--I3
		{
			[01]={{-1, 0},{ 1, 0}},
			[10]={{ 1, 0},{-1, 0}},
			[03]={{ 0, 1},{ 0,-1}},
			[30]={{ 0,-1},{ 0, 1}},
			[12]={{ 0, 1},{ 0,-1}},
			[21]={{ 0,-1},{ 0, 1}},
			[32]={{-1, 0},{ 1, 0}},
			[23]={{ 1, 0},{-1, 0}},
			[02]={{ 0,-1},{ 1,-1},{-1,-1}},
			[20]={{ 0, 1},{-1, 1},{ 1, 1}},
			[13]={{ 0,-1},{-1,-1},{ 1,-1}},
			[31]={{ 0, 1},{ 1, 1},{-1, 1}},
		},--C
		{
			[01]={{-1, 0},{ 0, 1}},
			[10]={{ 1, 0},{ 0, 1}},
			[03]={{ 1, 0},{ 0, 1}},
			[30]={{-1, 0},{ 0, 1}},
			[12]={{ 1, 0},{ 0, 2}},
			[21]={{ 0,-1},{-1, 0}},
			[32]={{-1, 0},{ 0, 2}},
			[23]={{ 0,-1},{-1, 0}},
			[02]={{ 0,-1},{ 0, 1}},
			[20]={{ 0, 1},{ 0,-1}},
			[13]={{-1, 0},{ 1, 0}},
			[31]={{ 1, 0},{-1, 0}},
		},--I2
		nil,--O1
	}
	TRS[2]=	reflect(TRS[1])--SZ
	TRS[4]=	reflect(TRS[3])--LJ
	TRS[9]=	reflect(TRS[8])--S5Z5
	TRS[11]=reflect(TRS[10])--PQ
	TRS[13]=reflect(TRS[12])--FE
	TRS[20]=reflect(TRS[19])--L5J5
	TRS[22]=reflect(TRS[21])--RY
	TRS[24]=reflect(TRS[23])--NH
	C_sym(TRS[8])C_sym(TRS[9])--S5Z5
	C_sym(TRS[25])C_sym(TRS[26])--I5I3
	for i=1,29 do collect(TRS[i])end
	pushZero(TRS)
end

local SRS
do
	SRS={
		{
			[01]={{-1,0},{-1, 1},{ 0,-2},{-1,-2}},
			[10]={{ 1,0},{ 1,-1},{ 0, 2},{ 1, 2}},
			[03]={{ 1,0},{ 1, 1},{ 0,-2},{ 1,-2}},
			[30]={{-1,0},{-1,-1},{ 0, 2},{-1, 2}},
			[12]={{ 1,0},{ 1,-1},{ 0, 2},{ 1, 2}},
			[21]={{-1,0},{-1, 1},{ 0,-2},{-1,-2}},
			[32]={{-1,0},{-1,-1},{ 0, 2},{-1, 2}},
			[23]={{ 1,0},{ 1, 1},{ 0,-2},{ 1,-2}},
			[02]={},[20]={},[13]={},[31]={},
		},--Z
		false,--S
		false,--J
		false,--L
		false,--T
		noKick,--O
		{
			[01]={{-2, 0},{ 1, 0},{-2,-1},{ 1, 2}},
			[10]={{ 2, 0},{-1, 0},{ 2, 1},{-1,-2}},
			[12]={{-1, 0},{ 2, 0},{-1, 2},{ 2,-1}},
			[21]={{ 1, 0},{-2, 0},{ 1,-2},{-2, 1}},
			[23]={{ 2, 0},{-1, 0},{ 2, 1},{-1,-2}},
			[32]={{-2, 0},{ 1, 0},{-2,-1},{ 1, 2}},
			[30]={{ 1, 0},{-2, 0},{ 1,-2},{-2, 1}},
			[03]={{-1, 0},{ 2, 0},{-1, 2},{ 2,-1}},
			[02]={},[20]={},[13]={},[31]={},
		}--I
	}
	collect(SRS[1])
	collect(SRS[7])
	pushZero(SRS)
	for i=2,5 do SRS[i]=SRS[1]end
	for i=8,29 do SRS[i]=SRS[1]end
end

local C2
do
	local L={{0,0},{-1,0},{1,0},{0,-1},{-1,-1},{1,-1},{-2,0},{2,0}}
	C2={
		{
			[01]=L,[10]=L,[12]=L,[21]=L,
			[23]=L,[32]=L,[30]=L,[03]=L,
			[02]=L,[20]=L,[13]=L,[31]=L,
		}
	}
	collect(C2[1])
	for i=2,29 do C2[i]=C2[1]end
end

local C2sym
do
	local L={{0,0},{-1,0},{1,0},{0,-1},{-1,-1},{1,-1},{-2,0},{2,0}}
	local R={{0,0},{1,0},{-1,0},{0,-1},{1,-1},{-1,-1},{2,0},{-2,0}}

	local Z={
		[01]=R,[10]=L,[03]=L,[30]=R,
		[12]=R,[21]=L,[32]=L,[23]=R,
		[02]=R,[20]=L,[13]=L,[31]=R,
	}
	collect(Z)
	local S=reflect(Z)
	collect(S)

	C2sym={
		Z,S,--Z,S
		Z,S,--J,L
		Z,--T
		noKick,--O
		Z,--I

		Z,S,--Z5,S5
		Z,S,--P,Q
		Z,S,--F,E
		Z,Z,Z,Z,--T5,U,V,W
		noKick,--X
		Z,S,--J5,L5
		Z,S,--R,Y
		Z,S,--N,H

		Z,Z,--I3,C
		Z,Z,--I2,O1
	}
end

local Classic={}
for i=1,29 do Classic[i]=noKick end

local None={}
for i=1,29 do None[i]=noKick_180 end

return{
	TRS=TRS,
	SRS=SRS,
	C2=C2,
	C2sym=C2sym,
	Classic=Classic,
	None=None,
}