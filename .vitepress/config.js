export default {
  title: "FIRE火记使用手册",
  description: "",
  base: '/',
  head: [
    ['link', { rel: 'icon', href: '/favicon.png' }],
  ],
  themeConfig: {
    outline: {
      level: [2, 3],
      label: '页面导航 ⬇️'
    },
    search: {
      provider: 'local'
    },
    sidebar: {
      '/': [
        {
          text: 'HI, FIRES',
          items: [
            { text: '🔥 FIRE火记', link: '/fire' },
            { text: '🤔 常见问题', link: '/faq' },
          ]
        },
        {
          text: '会员',
          items: [
            { text: '🎟 会员介绍 ᴾᴿᴼ', link: '/pro' },
          ]
        },
        {
          text: '资产',
          items: [
            { text: '📈 资产和负债', link: '/asset' },
          ]
        },
        {
          text: '账本',
          items: [
            { text: '📖 账本管理 ᴾᴿᴼ', link: '/book' },
          ]
        },
        {
          text: '分类',
          items: [
            { text: '🏷️ 分类管理', link: '/category' },
          ]
        },
        {
          text: '账单',
          items: [
            { text: '💰 记一笔', link: '/bill' },
            { text: '📊 账单统计', link: '/statistics' },
            { text: '🆚 账单对比', link: '/compare' },
          ]
        },
        {
          text: '预算',
          items: [
            { text: '📅 预算管理', link: '/budget' },
          ]
        },
        {
          text: '多币种',
          items: [
            { text: '🌍 本位币', link: '/currency' },
          ]
        },
        {
          text: '账单导入和导出',
          items: [
            { text: '⬆️ 账单导入', link: '/import' },
            { text: '⬇️ 账单导出', link: '/export' },
          ]
        },
        {
          text: '服务协议',
          items: [
            { text: '🔐 隐私政策', link: '/privacy' },
            { text: '👤 用户协议', link: '/user' }
          ]
        },
        {
          text: '关于我们',
          items: [
            { text: '🔄 版本更新', link: '/update' },
            { text: '😄 关于我们', link: '/about' }
          ]
        }
      ]
    }
  }
}
