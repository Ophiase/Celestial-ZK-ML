use astral_zkml::math;
use astral_zkml::math::signed::{
    I128SignedBasics, unsigned_to_signed, felt_to_i128, I128Div, I128Display,
};
use astral_zkml::math::wfloat::{
    WFloat, WFloatBasics, ZERO_WFLOAT, ONE_WFLOAT, NEG_WFLOAT, HALF_WFLOAT, DECIMAL_WFLOAT,
};
use astral_zkml::math::vector::{Vector, VectorBasics};
use astral_zkml::math::matrix::{Matrix, MatrixBasics};
use astral_zkml::contract::country_wise_contract::{
    CountryWiseContract, ICountryWiseContractDispatcher, ICountryWiseContractDispatcherTrait
};

use starknet::syscalls::deploy_syscall;
use starknet::ContractAddress;

// ------------------------------------------------------------------------------------

fn util_felt_addr(addr_felt: felt252) -> ContractAddress {
    addr_felt.try_into().unwrap()
}

fn deploy_contract() -> ICountryWiseContractDispatcher {
    let calldata: Span<felt252> = array![
        10, // max_propositions
        10, // min_filtered
        
        3, // n_countries
        'BEL',
        'FRA',
        'USA',

        3, // initial_validators
        'Akashi',
        'Ozu',
        'Higuchi',
        
        3, // initial_validators_countries
        0,
        1,
        2,

        // initial_weights : AUTOGENERATED in /contract/draft/model_weights.save
        3, 17, 5, 3618502788666131213697322783095070105623107215331596699973092056135872010978, 3618502788666131213697322783095070105623107215331596699973092056135871999038, 3618502788666131213697322783095070105623107215331596699973092056135872006546, 14389, 9683, 5, 1831, 3618502788666131213697322783095070105623107215331596699973092056135872017504, 3618502788666131213697322783095070105623107215331596699973092056135872018173, 3618502788666131213697322783095070105623107215331596699973092056135872011145, 3618502788666131213697322783095070105623107215331596699973092056135872019106, 5, 3618502788666131213697322783095070105623107215331596699973092056135872019697, 5319, 3618502788666131213697322783095070105623107215331596699973092056135872006955, 3618502788666131213697322783095070105623107215331596699973092056135872004983, 6139, 5, 3618502788666131213697322783095070105623107215331596699973092056135872015633, 3618502788666131213697322783095070105623107215331596699973092056135872006737, 1310, 3618502788666131213697322783095070105623107215331596699973092056135872020188, 3879, 5, 7623, 3618502788666131213697322783095070105623107215331596699973092056135871999187, 7865, 3618502788666131213697322783095070105623107215331596699973092056135872019575, 1739, 5, 3618502788666131213697322783095070105623107215331596699973092056135872017070, 3618502788666131213697322783095070105623107215331596699973092056135872014319, 3618502788666131213697322783095070105623107215331596699973092056135872008929, 13281, 20913, 5, 7361, 3618502788666131213697322783095070105623107215331596699973092056135872019047, 9284, 4949, 13552, 5, 3618502788666131213697322783095070105623107215331596699973092056135872019822, 3618502788666131213697322783095070105623107215331596699973092056135872015963, 8777, 5144, 11867, 5, 8222, 6098, 3618502788666131213697322783095070105623107215331596699973092056135872012876, 3618502788666131213697322783095070105623107215331596699973092056135872011480, 3618502788666131213697322783095070105623107215331596699973092056135872004753, 5, 3618502788666131213697322783095070105623107215331596699973092056135872010532, 1073, 10833, 3618502788666131213697322783095070105623107215331596699973092056135872017817, 3618502788666131213697322783095070105623107215331596699973092056135872014819, 5, 3618502788666131213697322783095070105623107215331596699973092056135872019335, 17219, 3618502788666131213697322783095070105623107215331596699973092056135872018955, 3618502788666131213697322783095070105623107215331596699973092056135872014975, 425, 5, 3914, 3618502788666131213697322783095070105623107215331596699973092056135872018034, 7631, 3618502788666131213697322783095070105623107215331596699973092056135872017908, 503, 5, 8463, 3618502788666131213697322783095070105623107215331596699973092056135872005157, 3618502788666131213697322783095070105623107215331596699973092056135872014705, 2707, 3618502788666131213697322783095070105623107215331596699973092056135872005030, 5, 3618502788666131213697322783095070105623107215331596699973092056135872007368, 13272, 6499, 8389, 6574, 5, 3618502788666131213697322783095070105623107215331596699973092056135871994807, 3618502788666131213697322783095070105623107215331596699973092056135872019750, 5440, 9493, 3618502788666131213697322783095070105623107215331596699973092056135872017030, 5, 1294, 3618502788666131213697322783095070105623107215331596699973092056135872006909, 9816, 3618502788666131213697322783095070105623107215331596699973092056135872020367, 1778, 5, 1005, 3618502788666131213697322783095070105623107215331596699973092056135871989028, 3618502788666131213697322783095070105623107215331596699973092056135872001014, 1165, 3618502788666131213697322783095070105623107215331596699973092056135872004109, 5, 289, 150, 6, 260, 232, 0, 5, 5, 706, 3618502788666131213697322783095070105623107215331596699973092056135872015413, 3618502788666131213697322783095070105623107215331596699973092056135872019269, 3618502788666131213697322783095070105623107215331596699973092056135872019788, 3618502788666131213697322783095070105623107215331596699973092056135872011234, 5, 3618502788666131213697322783095070105623107215331596699973092056135872012875, 6052, 4773, 6199, 3618502788666131213697322783095070105623107215331596699973092056135872010683, 5, 18690, 3618502788666131213697322783095070105623107215331596699973092056135872010496, 3618502788666131213697322783095070105623107215331596699973092056135872006226, 3618502788666131213697322783095070105623107215331596699973092056135872008134, 3618502788666131213697322783095070105623107215331596699973092056135872018061, 5, 7159, 3618502788666131213697322783095070105623107215331596699973092056135871986102, 3618502788666131213697322783095070105623107215331596699973092056135872003510, 6270, 15857, 5, 3618502788666131213697322783095070105623107215331596699973092056135872003307, 3618502788666131213697322783095070105623107215331596699973092056135872016876, 9329, 3618502788666131213697322783095070105623107215331596699973092056135871999896, 6195, 5, 3618502788666131213697322783095070105623107215331596699973092056135872019372, 3618502788666131213697322783095070105623107215331596699973092056135872019834, 3618502788666131213697322783095070105623107215331596699973092056135872020033, 1776, 927, 0, 5, 3, 3618502788666131213697322783095070105623107215331596699973092056135872017882, 3618502788666131213697322783095070105623107215331596699973092056135872011789, 5186, 3, 3618502788666131213697322783095070105623107215331596699973092056135872010018, 2451, 1494, 3, 1620, 26425, 3618502788666131213697322783095070105623107215331596699973092056135872007310, 3, 549, 3618502788666131213697322783095070105623107215331596699973092056135872007318, 961, 3, 5426, 2827, 3618502788666131213697322783095070105623107215331596699973092056135871995366, 3, 594970, 189508, 215554, 0
    ]
        .span();

    let (address0, _) = deploy_syscall(
        CountryWiseContract::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata, false
    )
        .unwrap();
    let contract0 = ICountryWiseContractDispatcher { contract_address: address0 };

    contract0
}

#[test]
fn check_contract() -> () {
    let dispatcher: ICountryWiseContractDispatcher = deploy_contract();
    println!("Dispatcher created");

    let _admin_0 = util_felt_addr('Akashi');
    let _admin_1 = util_felt_addr('Ozu');
    let _admin_2 = util_felt_addr('Higuchi');

    starknet::testing::set_contract_address(_admin_0);

    // -------------------------------------------------------------------

    let rawX = array![array![3618502788666131213697322783095070105623107215331596699973092056135871945953, 3618502788666131213697322783095070105623107215331596699973092056135871559980, 145762, 43507, 80955, 945948, 634083, 22985, 3618502788666131213697322783095070105623107215331596699973092056135871945986, 0, 3618502788666131213697322783095070105623107215331596699973092056135871698087, 3618502788666131213697322783095070105623107215331596699973092056135871798144, 2027262, 143450, 2027237, 1575002, 1591530,].span(), array![14730, 243011, 683994, 3618502788666131213697322783095070105623107215331596699973092056135871942938, 3618502788666131213697322783095070105623107215331596699973092056135871944024, 3618502788666131213697322783095070105623107215331596699973092056135870846117, 3618502788666131213697322783095070105623107215331596699973092056135870893381, 3618502788666131213697322783095070105623107215331596699973092056135871962720, 14573, 0, 1568078, 3618502788666131213697322783095070105623107215331596699973092056135870986120, 3618502788666131213697322783095070105623107215331596699973092056135870992462, 3618502788666131213697322783095070105623107215331596699973092056135871306613, 3618502788666131213697322783095070105623107215331596699973092056135870992462, 3618502788666131213697322783095070105623107215331596699973092056135871205625, 3618502788666131213697322783095070105623107215331596699973092056135871773460,].span(), array![3618502788666131213697322783095070105623107215331596699973092056135870883156, 169335, 3618502788666131213697322783095070105623107215331596699973092056135871002303, 3618502788666131213697322783095070105623107215331596699973092056135871913417, 3618502788666131213697322783095070105623107215331596699973092056135871912912, 3618502788666131213697322783095070105623107215331596699973092056135870225959, 3618502788666131213697322783095070105623107215331596699973092056135870238162, 3618502788666131213697322783095070105623107215331596699973092056135871925660, 3618502788666131213697322783095070105623107215331596699973092056135870883258, 0, 3618502788666131213697322783095070105623107215331596699973092056135871067929, 234007, 3618502788666131213697322783095070105623107215331596699973092056135870567686, 3618502788666131213697322783095070105623107215331596699973092056135871373146, 3618502788666131213697322783095070105623107215331596699973092056135870567707, 3618502788666131213697322783095070105623107215331596699973092056135870406057, 3618502788666131213697322783095070105623107215331596699973092056135870727577,].span(), array![3618502788666131213697322783095070105623107215331596699973092056135871597307, 317071, 1178683, 56985, 37228, 236030, 28093, 3618502788666131213697322783095070105623107215331596699973092056135872017549, 3618502788666131213697322783095070105623107215331596699973092056135871597342, 0, 3618502788666131213697322783095070105623107215331596699973092056135871698087, 3618502788666131213697322783095070105623107215331596699973092056135871529707, 545986, 3618502788666131213697322783095070105623107215331596699973092056135871966417, 546013, 432050, 3618502788666131213697322783095070105623107215331596699973092056135870947763,].span(), array![3618502788666131213697322783095070105623107215331596699973092056135871909944, 3618502788666131213697322783095070105623107215331596699973092056135871696714, 2283205, 3618502788666131213697322783095070105623107215331596699973092056135871949341, 3618502788666131213697322783095070105623107215331596699973092056135871954426, 3618502788666131213697322783095070105623107215331596699973092056135870963443, 3618502788666131213697322783095070105623107215331596699973092056135870953857, 3618502788666131213697322783095070105623107215331596699973092056135871966691, 3618502788666131213697322783095070105623107215331596699973092056135871909849, 0, 937920, 455468, 3618502788666131213697322783095070105623107215331596699973092056135870916929, 3618502788666131213697322783095070105623107215331596699973092056135871353454, 3618502788666131213697322783095070105623107215331596699973092056135870916928, 3618502788666131213697322783095070105623107215331596699973092056135871406347, 3618502788666131213697322783095070105623107215331596699973092056135871835846,].span(),].span();

    let rawY = array![array![594980, 189485, 215514,].span(), array![594972, 189479, 215554,].span(), array![594971, 189486, 215556,].span(), array![594975, 189493, 215535,].span(), array![594972, 189480, 215554,].span(),].span();

    let X = MatrixBasics::from_raw_felt(@rawX);
    let Y = MatrixBasics::from_raw_felt(@rawY);

    // -------------------------------------------------------------------

    let result = dispatcher.predict(X, false);
    println!("result : \n{result}");
    println!("wanted : \n{Y}");
 
    // -------------------------------------------------------------------
}