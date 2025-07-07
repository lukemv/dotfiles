
// Copyright 2023 ZSA Technology Labs, Inc <@zsa>
// Copyright 2023 Christopher Courtney, aka Drashna Jael're  (@drashna) <drashna@live.com>
// SPDX-License-Identifier: GPL-2.0-or-later

#include QMK_KEYBOARD_H

enum layers {
    _BASE,
    _FN,
    _MEDIA,
    _GAMING,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
        KC_GRAVE,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    TG(_GAMING),
        KC_EQUAL, KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS,
        KC_LSFT, KC_A, MT(MOD_LGUI, KC_S), KC_D, MT(MOD_LCTL, KC_F), KC_G,          KC_H, MT(MOD_RCTL, KC_J), KC_K, MT(MOD_RGUI, KC_L), KC_SCLN, RSFT_T(KC_QUOT),
        KC_LCTL, MT(MOD_LALT, KC_Z), KC_X, KC_C, KC_V, KC_B,                         KC_N, KC_M, KC_COMMA, KC_DOT, KC_SLSH, KC_ESC,
                                    KC_ENT, LT(_FN, KC_TAB),              KC_BSPC, LT(_MEDIA, KC_SPC)
    ),

    [_FN] = LAYOUT(
        KC_ESC,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,                        KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,
        KC_GRV,  KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,                      KC_7,    KC_8,    KC_9,    KC_MINS, KC_SLSH, KC_F12,
        _______, KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN,                      KC_4,    KC_5,    KC_6,    KC_PLUS, KC_ASTR, KC_BSPC,
        _______, _______, KC_LBRC, KC_RBRC, KC_LCBR, KC_RCBR,                      KC_1,    KC_2,    KC_3,    KC_DOT,  KC_EQL,  KC_ENT,
                                             _______, _______,    _______, KC_0
    ),

    [_MEDIA] = LAYOUT(
        RM_TOGG, QK_KB,   RM_NEXT, RGB_M_P, RM_VALD, RM_VALU,                      _______, _______, _______, _______, _______, QK_BOOT,
        _______, _______, KC_VOLD, KC_VOLU, KC_MUTE, _______,                      _______, _______, _______, _______, _______, _______,
        _______, KC_MPRV, KC_MNXT, KC_MSTP, KC_MPLY, _______,                      KC_LEFT, KC_DOWN, KC_UP  , KC_RIGHT, _______, _______,
        _______, _______, _______, _______, _______, _______,                      KC_HOME, KC_PGDN, KC_PGUP, KC_END, _______, _______,
                                             _______, _______,    _______, _______
    ),

    [_GAMING] = LAYOUT(
        KC_GRAVE,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    TG(_GAMING),
        KC_LCTL,   KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSLS,
        KC_LSFT,   KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_SPC,
        _______,   KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_ESC,
                                             KC_SPC, _______,    _______, _______
    ),
};

