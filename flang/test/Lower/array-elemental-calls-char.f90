! Test lowering of elemental calls with character argument
! without the VALUE attribute.
! RUN: bbc -o - %s | FileCheck %s

module char_elem

interface
elemental integer function elem(c)
  character(*), intent(in) :: c
end function

elemental integer function elem2(c, j)
  character(*), intent(in) :: c
  integer, intent(in) :: j
end function

end interface

contains

! CHECK-LABEL: func @_QMchar_elemPfoo1(
! CHECK-SAME: %[[VAL_15:.*]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_4:.*]]: !fir.boxchar<1>) {
subroutine foo1(i, c)
  integer :: i(10)
  character(*) :: c(10)
! CHECK-DAG:   %[[VAL_0:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_1:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_2:.*]] = constant 1 : index
! CHECK:   %[[VAL_3:.*]]:2 = fir.unboxchar %[[VAL_4]] : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1,?>>, index)
! CHECK:   %[[VAL_5:.*]] = fir.convert %[[VAL_3]]#0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<10x!fir.char<1,?>>>
! CHECK:   %[[VAL_6:.*]] = fir.shape %[[VAL_0]] : (index) -> !fir.shape<1>
! CHECK:   br ^bb1(%[[VAL_1]], %[[VAL_0]] : index, index)
! CHECK: ^bb1(%[[VAL_7:.*]]: index, %[[VAL_8:.*]]: index):
! CHECK:   %[[VAL_9:.*]] = cmpi sgt, %[[VAL_8]], %[[VAL_1]] : index
! CHECK:   cond_br %[[VAL_9]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_10:.*]] = addi %[[VAL_7]], %[[VAL_2]] : index
! CHECK:   %[[VAL_11:.*]] = fir.array_coor %[[VAL_5]](%[[VAL_6]]) %[[VAL_10]] typeparams %[[VAL_3]]#1 : (!fir.ref<!fir.array<10x!fir.char<1,?>>>, !fir.shape<1>, index, index) -> !fir.ref<!fir.char<1,?>>
! CHECK:   %[[VAL_12:.*]] = fir.emboxchar %[[VAL_11]], %[[VAL_3]]#1 : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_13:.*]] = fir.call @_QPelem(%[[VAL_12]]) : (!fir.boxchar<1>) -> i32
! CHECK:   %[[VAL_14:.*]] = fir.array_coor %[[VAL_15]](%[[VAL_6]]) %[[VAL_10]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_13]] to %[[VAL_14]] : !fir.ref<i32>
! CHECK:   %[[VAL_16:.*]] = subi %[[VAL_8]], %[[VAL_2]] : index
! CHECK:   br ^bb1(%[[VAL_10]], %[[VAL_16]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  i = elem(c)
end subroutine

! CHECK-LABEL: func @_QMchar_elemPfoo1b(
! CHECK-SAME: %[[VAL_33:.*]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_21:.*]]: !fir.boxchar<1>) {
subroutine foo1b(i, c)
  integer :: i(10)
  character(10) :: c(10)
! CHECK-DAG:   %[[VAL_17:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_18:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_19:.*]] = constant 1 : index
! CHECK:   %[[VAL_20:.*]]:2 = fir.unboxchar %[[VAL_21]] : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1,?>>, index)
! CHECK:   %[[VAL_22:.*]] = fir.convert %[[VAL_20]]#0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.array<10x!fir.char<1,10>>>
! CHECK:   %[[VAL_23:.*]] = fir.shape %[[VAL_17]] : (index) -> !fir.shape<1>
! CHECK:   br ^bb1(%[[VAL_18]], %[[VAL_17]] : index, index)
! CHECK: ^bb1(%[[VAL_24:.*]]: index, %[[VAL_25:.*]]: index):
! CHECK:   %[[VAL_26:.*]] = cmpi sgt, %[[VAL_25]], %[[VAL_18]] : index
! CHECK:   cond_br %[[VAL_26]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_27:.*]] = addi %[[VAL_24]], %[[VAL_19]] : index
! CHECK:   %[[VAL_28:.*]] = fir.array_coor %[[VAL_22]](%[[VAL_23]]) %[[VAL_27]] : (!fir.ref<!fir.array<10x!fir.char<1,10>>>, !fir.shape<1>, index) -> !fir.ref<!fir.char<1,10>>
! CHECK:   %[[VAL_29:.*]] = fir.convert %[[VAL_28]] : (!fir.ref<!fir.char<1,10>>) -> !fir.ref<!fir.char<1,?>>
! CHECK:   %[[VAL_30:.*]] = fir.emboxchar %[[VAL_29]], %[[VAL_17]] : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_31:.*]] = fir.call @_QPelem(%[[VAL_30]]) : (!fir.boxchar<1>) -> i32
! CHECK:   %[[VAL_32:.*]] = fir.array_coor %[[VAL_33]](%[[VAL_23]]) %[[VAL_27]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_31]] to %[[VAL_32]] : !fir.ref<i32>
! CHECK:   %[[VAL_34:.*]] = subi %[[VAL_25]], %[[VAL_19]] : index
! CHECK:   br ^bb1(%[[VAL_27]], %[[VAL_34]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  i = elem(c)
end subroutine

! CHECK-LABEL: func @_QMchar_elemPfoo2(
! CHECK-SAME: %[[VAL_50:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_47:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_39:.*]]: !fir.boxchar<1>) {
subroutine foo2(i, j, c)
! CHECK-DAG:   %[[VAL_35:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_36:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_37:.*]] = constant 1 : index
! CHECK:   %[[VAL_38:.*]]:2 = fir.unboxchar %[[VAL_39]] : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1,?>>, index)
! CHECK:   %[[VAL_40:.*]] = fir.shape %[[VAL_35]] : (index) -> !fir.shape<1>
! CHECK:   br ^bb1(%[[VAL_36]], %[[VAL_35]] : index, index)
! CHECK: ^bb1(%[[VAL_41:.*]]: index, %[[VAL_42:.*]]: index):
! CHECK:   %[[VAL_43:.*]] = cmpi sgt, %[[VAL_42]], %[[VAL_36]] : index
! CHECK:   cond_br %[[VAL_43]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_44:.*]] = fir.emboxchar %[[VAL_38]]#0, %[[VAL_38]]#1 : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_45:.*]] = addi %[[VAL_41]], %[[VAL_37]] : index
! CHECK:   %[[VAL_46:.*]] = fir.array_coor %[[VAL_47]](%[[VAL_40]]) %[[VAL_45]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   %[[VAL_48:.*]] = fir.call @_QPelem2(%[[VAL_44]], %[[VAL_46]]) : (!fir.boxchar<1>, !fir.ref<i32>) -> i32
! CHECK:   %[[VAL_49:.*]] = fir.array_coor %[[VAL_50]](%[[VAL_40]]) %[[VAL_45]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_48]] to %[[VAL_49]] : !fir.ref<i32>
! CHECK:   %[[VAL_51:.*]] = subi %[[VAL_42]], %[[VAL_37]] : index
! CHECK:   br ^bb1(%[[VAL_45]], %[[VAL_51]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  integer :: i(10), j(10)
  character(*) :: c
  i = elem2(c, j)
end subroutine

! CHECK-LABEL: func @_QMchar_elemPfoo2b(
! CHECK-SAME: %[[VAL_67:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_64:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_56:.*]]: !fir.boxchar<1>) {
subroutine foo2b(i, j, c)
  integer :: i(10), j(10)
  character(10) :: c
! CHECK-DAG:   %[[VAL_52:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_53:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_54:.*]] = constant 1 : index
! CHECK:   %[[VAL_55:.*]]:2 = fir.unboxchar %[[VAL_56]] : (!fir.boxchar<1>) -> (!fir.ref<!fir.char<1,?>>, index)
! CHECK:   %[[VAL_57:.*]] = fir.shape %[[VAL_52]] : (index) -> !fir.shape<1>
! CHECK:   br ^bb1(%[[VAL_53]], %[[VAL_52]] : index, index)
! CHECK: ^bb1(%[[VAL_58:.*]]: index, %[[VAL_59:.*]]: index):
! CHECK:   %[[VAL_60:.*]] = cmpi sgt, %[[VAL_59]], %[[VAL_53]] : index
! CHECK:   cond_br %[[VAL_60]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_61:.*]] = fir.emboxchar %[[VAL_55]]#0, %[[VAL_52]] : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_62:.*]] = addi %[[VAL_58]], %[[VAL_54]] : index
! CHECK:   %[[VAL_63:.*]] = fir.array_coor %[[VAL_64]](%[[VAL_57]]) %[[VAL_62]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   %[[VAL_65:.*]] = fir.call @_QPelem2(%[[VAL_61]], %[[VAL_63]]) : (!fir.boxchar<1>, !fir.ref<i32>) -> i32
! CHECK:   %[[VAL_66:.*]] = fir.array_coor %[[VAL_67]](%[[VAL_57]]) %[[VAL_62]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_65]] to %[[VAL_66]] : !fir.ref<i32>
! CHECK:   %[[VAL_68:.*]] = subi %[[VAL_59]], %[[VAL_54]] : index
! CHECK:   br ^bb1(%[[VAL_62]], %[[VAL_68]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  i = elem2(c, j)
end subroutine

! CHECK-LABEL: func @_QMchar_elemPfoo3(
! CHECK-SAME: %[[VAL_88:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_79:[^:]+]]: !fir.ref<!fir.array<10xi32>>)
subroutine foo3(i, j)
  integer :: i(10), j(10)
! CHECK-DAG:   %[[VAL_69:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_70:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_71:.*]] = constant 1 : index
! CHECK-DAG:   %[[VAL_72:.*]] = fir.alloca !fir.char<1> {uniq_name = ""}
! CHECK:   %[[VAL_73:.*]] = fir.shape %[[VAL_69]] : (index) -> !fir.shape<1>
! CHECK:   br ^bb1(%[[VAL_70]], %[[VAL_69]] : index, index)
! CHECK: ^bb1(%[[VAL_74:.*]]: index, %[[VAL_75:.*]]: index):
! CHECK:   %[[VAL_76:.*]] = cmpi sgt, %[[VAL_75]], %[[VAL_70]] : index
! CHECK:   cond_br %[[VAL_76]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_77:.*]] = addi %[[VAL_74]], %[[VAL_71]] : index
! CHECK:   %[[VAL_78:.*]] = fir.array_coor %[[VAL_79]](%[[VAL_73]]) %[[VAL_77]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   %[[VAL_80:.*]] = fir.load %[[VAL_78]] : !fir.ref<i32>
! CHECK:   %[[VAL_81:.*]] = fir.convert %[[VAL_80]] : (i32) -> i8
! CHECK:   %[[VAL_82:.*]] = fir.undefined !fir.char<1>
! CHECK:   %[[VAL_83:.*]] = fir.insert_value %[[VAL_82]], %[[VAL_81]], [0 : index] : (!fir.char<1>, i8) -> !fir.char<1>
! CHECK:   fir.store %[[VAL_83]] to %[[VAL_72]] : !fir.ref<!fir.char<1>>
! CHECK:   %[[VAL_84:.*]] = fir.convert %[[VAL_72]] : (!fir.ref<!fir.char<1>>) -> !fir.ref<!fir.char<1,?>>
! CHECK:   %[[VAL_85:.*]] = fir.emboxchar %[[VAL_84]], %[[VAL_71]] : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_86:.*]] = fir.call @_QPelem(%[[VAL_85]]) : (!fir.boxchar<1>) -> i32
! CHECK:   %[[VAL_87:.*]] = fir.array_coor %[[VAL_88]](%[[VAL_73]]) %[[VAL_77]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_86]] to %[[VAL_87]] : !fir.ref<i32>
! CHECK:   %[[VAL_89:.*]] = subi %[[VAL_75]], %[[VAL_71]] : index
! CHECK:   br ^bb1(%[[VAL_77]], %[[VAL_89]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  i = elem(char(j))
end subroutine

! CHECK-LABEL: func @_QMchar_elemPfoo4(
! CHECK-SAME: %[[VAL_106:[^:]+]]: !fir.ref<!fir.array<10xi32>>,
! CHECK-SAME: %[[VAL_103:[^:]+]]: !fir.ref<!fir.array<10xi32>>)
subroutine foo4(i, j)
  integer :: i(10), j(10)
! CHECK-DAG:   %[[VAL_90:.*]] = constant 5 : index
! CHECK-DAG:   %[[VAL_91:.*]] = constant 10 : index
! CHECK-DAG:   %[[VAL_92:.*]] = constant 0 : index
! CHECK-DAG:   %[[VAL_93:.*]] = constant 1 : index
! CHECK:   %[[VAL_94:.*]] = fir.shape %[[VAL_91]] : (index) -> !fir.shape<1>
! CHECK:   %[[VAL_95:.*]] = fir.address_of(@{{.*}}) : !fir.ref<!fir.char<1,5>>
! CHECK:   br ^bb1(%[[VAL_92]], %[[VAL_91]] : index, index)
! CHECK: ^bb1(%[[VAL_96:.*]]: index, %[[VAL_97:.*]]: index):
! CHECK:   %[[VAL_98:.*]] = cmpi sgt, %[[VAL_97]], %[[VAL_92]] : index
! CHECK:   cond_br %[[VAL_98]], ^bb2, ^bb3
! CHECK: ^bb2:
! CHECK:   %[[VAL_99:.*]] = fir.convert %[[VAL_95]] : (!fir.ref<!fir.char<1,5>>) -> !fir.ref<!fir.char<1,?>>
! CHECK:   %[[VAL_100:.*]] = fir.emboxchar %[[VAL_99]], %[[VAL_90]] : (!fir.ref<!fir.char<1,?>>, index) -> !fir.boxchar<1>
! CHECK:   %[[VAL_101:.*]] = addi %[[VAL_96]], %[[VAL_93]] : index
! CHECK:   %[[VAL_102:.*]] = fir.array_coor %[[VAL_103]](%[[VAL_94]]) %[[VAL_101]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   %[[VAL_104:.*]] = fir.call @_QPelem2(%[[VAL_100]], %[[VAL_102]]) : (!fir.boxchar<1>, !fir.ref<i32>) -> i32
! CHECK:   %[[VAL_105:.*]] = fir.array_coor %[[VAL_106]](%[[VAL_94]]) %[[VAL_101]] : (!fir.ref<!fir.array<10xi32>>, !fir.shape<1>, index) -> !fir.ref<i32>
! CHECK:   fir.store %[[VAL_104]] to %[[VAL_105]] : !fir.ref<i32>
! CHECK:   %[[VAL_107:.*]] = subi %[[VAL_97]], %[[VAL_93]] : index
! CHECK:   br ^bb1(%[[VAL_101]], %[[VAL_107]] : index, index)
! CHECK: ^bb3:
! CHECK:   return
  i = elem2("hello", j)
end subroutine

!! TODO: character return for elemental functions.
!
! elemental character(10) function elem_return_char(j)
!   integer, intent(in) :: j
!   elem_return_char = char(j)
! end function
! 
! subroutine foo6(i, c)
!   implicit none
!   integer :: i(10)
!   character(*) :: c(10)
!   c = elem_return_char(i)
! end subroutine

end module
