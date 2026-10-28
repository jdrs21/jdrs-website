<?php
header('Content-Type: text/html; charset=UTF-8');

$to = 'info@jdrs21.jp';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: https://jdrs21.jp/');
    exit;
}

function clean($val) {
    return mb_convert_encoding(trim($val), 'UTF-8', 'auto');
}

$company       = isset($_POST['company'])       ? clean($_POST['company'])       : '';
$name          = isset($_POST['name'])          ? clean($_POST['name'])          : '';
$kana          = isset($_POST['kana'])          ? clean($_POST['kana'])          : '';
$position      = isset($_POST['position'])      ? clean($_POST['position'])      : '';
$address       = isset($_POST['address'])       ? clean($_POST['address'])       : '';
$email         = isset($_POST['email'])         ? clean($_POST['email'])         : '';
$email_confirm = isset($_POST['email_confirm']) ? clean($_POST['email_confirm']) : '';
$phone         = isset($_POST['phone'])         ? clean($_POST['phone'])         : '';
$type          = isset($_POST['type'])          ? clean($_POST['type'])          : '';
$month         = isset($_POST['month'])         ? clean($_POST['month'])         : '';
$day           = isset($_POST['day'])           ? clean($_POST['day'])           : '';
$count         = isset($_POST['count'])         ? clean($_POST['count'])         : '';
$media_arr     = isset($_POST['media']) && is_array($_POST['media'])
                 ? array_map('clean', $_POST['media']) : [];
$media         = !empty($media_arr) ? implode('、', $media_arr) : '';
$reason        = isset($_POST['reason'])        ? clean($_POST['reason'])        : '';
$other         = isset($_POST['other'])         ? clean($_POST['other'])         : '';

if (empty($company) || empty($name) || empty($email) || empty($phone) || empty($type) || empty($month)) {
    header('Location: https://jdrs21.jp/?error=1');
    exit;
}

$subject = 'JDRSウェブサイトからお問い合わせがありました';

$body  = "企業（団体）名：{$company}\r\n";
$body .= "参加（代表）者氏名：{$name}\r\n";
$body .= "フリガナ：{$kana}\r\n";
$body .= "役職：{$position}\r\n";
$body .= "\r\n";
$body .= "住所　都道府県市町村含む：{$address}\r\n";
$body .= "参加者数：{$count}\r\n";
$body .= "\r\n";
$body .= "連絡先メール：{$email}\r\n";
$body .= "連絡先メール（確認）：{$email_confirm}\r\n";
$body .= "電話番号：{$phone}\r\n";
$body .= "\r\n";
$body .= "お問い合わせ項目：{$type}\r\n";
$body .= "希望月：{$month}\r\n";
$body .= "希望日：{$day}\r\n";
$body .= "\r\n";
$body .= "当機構の取組みをどのようにしてお知りになりましたか？：{$media}\r\n";
$body .= "\r\n";
$body .= "申込経緯：{$reason}\r\n";
$body .= "その他お問い合わせ欄：{$other}\r\n";

$from_name = mb_encode_mimeheader('（一社）日本災害救助支援機構', 'UTF-8', 'B');
$headers  = "From: {$from_name} <noreply@jdrs21.jp>\r\n";
$headers .= "Reply-To: {$email}\r\n";
$headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

// info@jdrs21.jp への通知メール
$result = mb_send_mail($to, $subject, $body, $headers);

// 申込者への受付完了メール
$subject_user = 'お問い合わせを受け付けました【JDRS 一般社団法人 日本災害救助支援機構】';
$body_user  = "{$name} 様\r\n\r\n";
$body_user .= "この度はお問い合わせいただきありがとうございます。\r\n";
$body_user .= "以下の内容でお問い合わせを受け付けました。\r\n";
$body_user .= "担当者よりご連絡させていただきますので、\r\n";
$body_user .= "今しばらくお待ちください。\r\n\r\n";
$body_user .= "============================================\r\n";
$body_user .= "企業（団体）名：{$company}\r\n";
$body_user .= "参加（代表）者氏名：{$name}\r\n";
$body_user .= "電話番号：{$phone}\r\n";
$body_user .= "お問い合わせ項目：{$type}\r\n";
$body_user .= "============================================\r\n\r\n";
$body_user .= "ご不明な点がございましたら下記までお問い合わせください。\r\n";
$body_user .= "──────────────────────────\r\n";
$body_user .= "一般社団法人 日本災害救助支援機構（JDRS）\r\n";
$body_user .= "Email：info@jdrs21.jp\r\n";
$body_user .= "TEL：089-932-2394\r\n";
$body_user .= "Web：https://jdrs21.jp\r\n";
$body_user .= "──────────────────────────\r\n";

$headers_user  = "From: {$from_name} <noreply@jdrs21.jp>\r\n";
$headers_user .= "Content-Type: text/plain; charset=UTF-8\r\n";
mb_send_mail($email, $subject_user, $body_user, $headers_user);

if ($result) {
    header('Location: https://jdrs21.jp/contact-thanks.html');
} else {
    header('Location: https://jdrs21.jp/?error=2');
}
exit;
?>
