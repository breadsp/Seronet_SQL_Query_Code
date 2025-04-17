
	

select distinct Visit_Info_ID, Split_List, row_val, 
	case when Split_List = 'Does not have Cancer' then 0 
		 when Split_List in ("Not Reported", "Unknown") then -1
    else split_val end as 'Cancer Level'  from 
(select Visit_Info_ID , `Original Cancer Name`, `Harmonized Cancer Name`, Split_List,
	if(Visit_Info_ID <> @v, @row_val:= @row_val + 1,  @row_val)  row_val,
	
    if(Visit_Info_ID <> @v and  @split_val >= 1, @split_val:=1,
		if (Visit_Info_ID = @v and Split_List <> @p, @split_val:= @split_val +1,
		if (Visit_Info_ID = @v and Split_List = @p, @split_val, @split_val=50))) split_val,
    
	@p:=Split_List p,
	@v:=Visit_Info_ID v
    
    #if(Visit_Info_ID <> @v, @rn:=1, @cn:=@cn+1) cn2,
    #if (Split_List = @p , @rn:=1 ,@rn:=@rn+1) rn,
	#	@p:=Split_List p,
	#if(Visit_Info_ID = @v, @cn:=1, @cn:=@cn+1) cn,
    #		@v:=Visit_Info_ID v
		from Normalized_Cancer_Names
        cross join (select @split_val:=1, @p:=null, @row_val:=0) r
		order by Visit_Info_ID, Split_List) as new_tab
	#group by Visit_Info_ID 
  #where Visit_Info_ID = '27_400212 : B01'
