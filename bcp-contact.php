<?php
header('Content-Type: text/html; charset=UTF-8');

$to_admin = 'info@jdrs21.jp';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: https://jdrs21.jp/bcp-form.html');
    exit;
}

function clean($val) {
    return mb_convert_encoding(trim($val), 'UTF-8', 'auto');
}

$name       = isset($_POST['name'])       ? clean($_POST['name'])       : '';
$kana       = isset($_POST['kana'])       ? clean($_POST['kana'])       : '';
$email      = isset($_POST['email'])      ? clean($_POST['email'])      : '';
$tel        = isset($_POST['tel'])        ? clean($_POST['tel'])        : '';
$facility   = isset($_POST['facility'])   ? clean($_POST['facility'])   : '';
$type       = isset($_POST['type'])       ? clean($_POST['type'])       : '';
$dept       = isset($_POST['dept'])       ? clean($_POST['dept'])       : '';
$address    = isset($_POST['address'])    ? clean($_POST['address'])    : '';
$dates_arr  = isset($_POST['session-dates']) && is_array($_POST['session-dates'])
              ? array_map('clean', $_POST['session-dates']) : [];
$dates      = !empty($dates_arr) ? implode("\r\n　・", $dates_arr) : '（未選択）';
$terminals  = isset($_POST['terminals'])  ? clean($_POST['terminals'])  : '';
$attendance = isset($_POST['attendance']) ? clean($_POST['attendance']) : '';
$note       = isset($_POST['note'])       ? clean($_POST['note'])       : '';

if (empty($name) || empty($email) || empty($facility)) {
    header('Location: https://jdrs21.jp/bcp-form.html?error=1');
    exit;
}

// ── info@jdrs21.jp への通知メール ──
$subject_admin = '【お申し込み】２０２６下半期 BCP無料オンライン教育　' . $name . '様';
$body_admin  = "【２０２６下半期 BCP無料オンライン教育　お申し込み】\r\n\r\n";
$body_admin .= "■ ご担当者情報\r\n";
$body_admin .= "お名前：{$name}\r\n";
$body_admin .= "フリガナ：" . ($kana ?: '―') . "\r\n";
$body_admin .= "メールアドレス：{$email}\r\n";
$body_admin .= "電話番号：" . ($tel ?: '―') . "\r\n\r\n";
$body_admin .= "■ 所属先情報\r\n";
$body_admin .= "施設名・団体名：{$facility}\r\n";
$body_admin .= "業種：{$type}\r\n";
$body_admin .= "部署・役職：" . ($dept ?: '―') . "\r\n";
$body_admin .= "所在地（都道府県）：" . ($address ?: '―') . "\r\n\r\n";
$body_admin .= "■ 参加希望日程\r\n";
$body_admin .= "　・{$dates}\r\n\r\n";
$body_admin .= "接続端末数：" . ($terminals ? $terminals . '台' : '―') . "\r\n";
$body_admin .= "参加形式：" . ($attendance ?: '―') . "\r\n\r\n";
$body_admin .= "■ ご質問・備考\r\n";
$body_admin .= ($note ?: '特になし') . "\r\n";

$from_name_admin = mb_encode_mimeheader('（一社）日本災害救助支援機構', 'UTF-8', 'B');
$headers_admin  = "From: {$from_name_admin} <noreply@jdrs21.jp>\r\n";
$headers_admin .= "Reply-To: {$email}\r\n";
$headers_admin .= "Content-Type: text/plain; charset=UTF-8\r\n";
mb_send_mail($to_admin, $subject_admin, $body_admin, $headers_admin);

// ── 申込者への受付完了メール ──
$subject_user = '【受付完了】２０２６下半期 BCP無料オンライン教育　お申し込みありがとうございます';
$body_user  = "{$name} 様\r\n\r\n";
$body_user .= "この度は２０２６下半期 BCP無料オンライン教育にお申し込みいただき、\r\n";
$body_user .= "誠にありがとうございます。\r\n\r\n";
$body_user .= "以下の内容でお申し込みを受け付けました。\r\n";
$body_user .= "============================================\r\n";
$body_user .= "施設名・団体名：{$facility}\r\n";
$body_user .= "お名前：{$name}\r\n\r\n";
$body_user .= "■ ご参加希望日程\r\n";
$body_user .= "　・{$dates}\r\n";
$body_user .= "============================================\r\n\r\n";
$body_user .= "各開催１週間前および３日前に、Zoom URLや教育資料等の詳細を\r\n";
$body_user .= "このメールアドレス宛にご案内いたします。\r\n\r\n";
$body_user .= "お申し込みのタイミングによっては満席の場合がございます。\r\n";
$body_user .= "その際は別途ご連絡いたします。\r\n\r\n";
$body_user .= "ご不明な点がございましたら下記までお問い合わせください。\r\n";
$body_user .= "──────────────────────────\r\n";
$body_user .= "一般社団法人 日本災害救助支援機構（JDRS）\r\n";
$body_user .= "Email：info@jdrs21.jp\r\n";
$body_user .= "Web：https://jdrs21.jp\r\n";
$body_user .= "──────────────────────────\r\n";

$headers_user  = "From: info@jdrs21.jp\r\n";
$headers_user .= "Content-Type: text/plain; charset=UTF-8\r\n";
mb_send_mail($email, $subject_user, $body_user, $headers_user);

header('Location: https://jdrs21.jp/contact-thanks.html');
exit;
?>
