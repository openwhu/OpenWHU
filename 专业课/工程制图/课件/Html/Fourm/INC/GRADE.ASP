<%
function grade(level)
dim user_level
Select Case level
	case 1
	user_level="新手上路"
	case 2
	user_level="论坛游民"
	case 3
	user_level="论坛游侠"
	case 4
	user_level="业余侠客"
	case 5
	user_level="职业侠客"
	case 6
	user_level="侠之大者"
	case 7
	user_level="黑侠"
	case 8
	user_level="蝙蝠侠"
	case 9
	user_level="蜘蛛侠"
	case 10
	user_level="青蜂侠"
	case 11
	user_level="小飞侠"
	case 12
	user_level="火箭侠"
	case 13
	user_level="蒙面侠"
	case 14
	user_level="城市猎人"
	case 15
	user_level="罗宾汉"
	case 16
	user_level="阿诺"
	case 17
	user_level="侠圣"
	case 18
	user_level="贵宾"
	case 19
	user_level="老师"
	case 20
	user_level="总老师"
	Case Else
	user_level="新手上路"
end Select
	grade=user_level
end function

function point(p)
dim level_point
Select Case p
	case 1
	level_point=0
	case 2
	level_point=100
	case 3
	level_point=200
	case 4
	level_point=300
	case 5
	level_point=400
	case 6
	level_point=500
	case 7
	level_point=600
	case 8
	level_point=700
	case 9
	level_point=800
	case 10
	level_point=900
	case 11
	level_point=1000
	case 12
	level_point=1200
	case 13
	level_point=1400
	case 14
	level_point=1600
	case 15
	level_point=1800
	case 16
	level_point=2000
	case 17
	level_point=2200
end select
point=level_point
end function

function gradepic(pic)
dim level_pic
Select Case pic
case 1
level_pic="level1.gif"
case 2
level_pic="level2.gif"
case 3
level_pic="level3.gif"
case 4
level_pic="level4.gif"
case 5
level_pic="level5.gif"
case 6
level_pic="level6.gif"
case 7
level_pic="level7.gif"
case 8
level_pic="level7.gif"
case 9
level_pic="level7.gif"
case 10
level_pic="level7.gif"
case 11
level_pic="level7.gif"
case 12
level_pic="level7.gif"
case 13
level_pic="level7.gif"
case 14
level_pic="level7.gif"
case 15
level_pic="level7.gif"
case 16
level_pic="level7.gif"
case 17
level_pic="level7.gif"
case 18
level_pic="level7.gif"
case 19
level_pic="level7.gif"
case 20
level_pic="level7.gif"
end select
gradepic=level_pic
end function
%>